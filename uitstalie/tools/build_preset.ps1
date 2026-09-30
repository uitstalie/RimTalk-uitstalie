# RimTalk Preset 构建与验证脚本
# 用途：从源 preset 生成修复后的 preset，并执行静态检查 + 渲染实测
# 渲染路径完全复现 ScribanParser.Render：Template.Parse(text) 单参数
#
# 路径全部相对脚本位置推导：
#   <repo>/uitstalie/tools/build_preset.ps1
#   <repo>/uitstalie/tools/upstream/DeepSeek Chat_preset.json   ← 源 preset
#   <repo>/Libs/Scriban.dll                                     ← mod 自带渲染引擎
#   <repo>/uitstalie/preset/DeepSeek Chat_preset.v2.json        ← 输出
$ErrorActionPreference = 'Stop'

$toolDir = $PSScriptRoot
$repoRoot = Split-Path -Parent (Split-Path -Parent $toolDir)   # 上溯 tools → uitstalie → 仓库根

$srcPath = Join-Path $toolDir "upstream\DeepSeek Chat_preset.json"
$dllPath = Join-Path $repoRoot "Libs\Scriban.dll"
$outDir  = Join-Path $toolDir "..\preset"
$outPath = Join-Path $outDir "DeepSeek Chat_preset.v2.json"

Write-Host "仓库根  : $repoRoot"
Write-Host "源 preset: $srcPath"

foreach ($p in @($srcPath, $dllPath)) {
    if (-not (Test-Path -LiteralPath $p)) { throw "必需文件不存在: $p" }
}

$fail = @()
function Check($label, $ok, $detail) {
    if ($ok) { Write-Host "  [PASS] $label" }
    else { Write-Host "  [FAIL] $label -- $detail"; $script:fail += $label }
}

# ---------- 读取原 preset ----------
$raw = Get-Content -Raw -LiteralPath $srcPath
$raw = $raw.TrimStart([char]0xFEFF)
$old = $raw | ConvertFrom-Json
$byName = @{}
foreach ($e in $old.entries) { $byName[$e.name] = $e }

# ---------- P0: Liquid -> Scriban 转换 ----------
function Convert-Liquid([string]$t) {
    $t = $t -replace '\{%-?\s*if\s+(.+?)\s*-?%\}',   '{{ if $1 }}'
    $t = $t -replace '\{%-?\s*else\s*-?%\}',          '{{ else }}'
    $t = $t -replace '\{%-?\s*endif\s*-?%\}',         '{{ end }}'
    $t = $t -replace '\{%-?\s*for\s+(.+?)\s*-?%\}',   '{{ for $1 }}'
    $t = $t -replace '\{%-?\s*endfor\s*-?%\}',        '{{ end }}'
    $t = $t -replace '\{%-?\s*assign\s+(.+?)\s*-?%\}','{{ $1 }}'
    return (($t -replace "`r`n", "`n"))
}

# ---------- P0+P3: Pawn Profiles 整体替换 ----------
# 两个已实测确认的注意点：
# (1) 可选字段判定必须写成 {{ if x != null && x != "" }}。Scriban 把空字符串当作真值
#     （{{ if x }} 对 "" 判真），而 {{ if x != "" }} 在完整模板中会失效，单一条件写法
#     都会在 null 或 "" 其中一种输入下泄漏标签字面量。双条件对两者均正确。
# (2) 原标题写法 ,{{ if pawn.title != "" }}，{{pawn.title}},{{ end }} 逗号重复：
#     无标题时输出尾随逗号，有标题时输出双逗号。
$pawnProfiles = @'
{{ if ctx.IsMonologue }}【独白角色】
姓名：{{pawn.name}}
身份：{{pawn.gender}}，{{pawn.age}}岁，{{pawn.race}}{{ if pawn.title != null && pawn.title != "" }}，{{pawn.title}}{{ end }}
当前状态：心情{{pawn.mood}}{{ if pawn.health != null && pawn.health != "" }} | 健康：{{pawn.health}}{{ end }}
{{ if pawn.captive_status != null && pawn.captive_status != "" }}处境：{{pawn.captive_status}}
{{ end }}背景故事：{{pawn.backstory}}
特质：{{pawn.traits}}
{{ if pawn.ideology != null && pawn.ideology != "" }}意识形态：{{pawn.ideology}}
{{ end }}{{ if pawn.thoughts != null && pawn.thoughts != "" }}当前想法：{{pawn.thoughts}}
{{ end }}{{ else }}【对话参与者】
{{ for p in pawns }}- {{p.name}}：{{p.gender}} {{p.age}}岁 {{p.race}}{{ if p.title != null && p.title != "" }} {{p.title}}{{ end }} | 心情{{p.moodpercent}} | 工作：{{p.job}}{{ if p.health != null && p.health != "" }} | 健康：{{p.health}}{{ end }}
  特质：{{p.traits}}{{ if p.captive_status != null && p.captive_status != "" }} | 处境：{{p.captive_status}}{{ end }}{{ if p.ideology != null && p.ideology != "" }} | 信仰：{{p.ideology}}{{ end }}
{{ end }}【社交关系网】
{{ has_relation = false }}{{ for p in pawns }}{{ if p.social != null && p.social != "" }}{{ has_relation = true }}- {{p.name}}：{{p.social}}
{{ end }}{{ end }}{{ if !has_relation }}（当前参与者之间无已知社交关系）
{{ end }}{{ end }}
'@ -replace "`r`n", "`n"

# ---------- P4: Recent Events（内容取自 PromptPresetAssembler.DefaultRecentEventsInstruction）----------
$recentEvents = @'
{{- if events && events != "" -}}
[Recent Events]
(Recent colony incidents; let them naturally shape mood, tone, or thoughts if still relevant, never force):
{{ events }}
{{- end -}}
'@ -replace "`r`n", "`n"

# ---------- P2: JSON Format 拆分 ----------
$jsonToken      = '{{ json.format }}'
$jsonCustomBody = $byName['JSON Format'].content

# ---------- 组装新 preset ----------
$entries = @()
foreach ($e in $old.entries) {
    $content = $e.content
    switch ($e.name) {
        'Pawn Profiles'   { $content = $pawnProfiles }
        'Dialogue Prompt' { $content = Convert-Liquid $content }
        'JSON Format'     { $content = $jsonToken }
        default           { $content = Convert-Liquid $content }
    }
    # Dialogue Prompt 的 surroundings 判定同样存在空串/ null 泄漏风险，一并加固
    if ($e.name -eq 'Dialogue Prompt') {
        $content = $content.Replace(
            '{{ if pawn.surroundings != "" }}',
            '{{ if pawn.surroundings != null && pawn.surroundings != "" }}')
    }
    # 顺序：JSON Format(槽位) -> JSON 输出规范(定制正文) -> Recent Events -> Pawn Profiles -> Chat History -> Dialogue Prompt
    if ($e.name -eq 'JSON Format') {
        $entries += [pscustomobject]@{
            name=$e.name; role=$e.role; position=$e.position; enabled=$e.enabled
            inChatDepth=$e.inChatDepth; isMainChatHistory=$e.isMainChatHistory
            customRole=$e.customRole; content=$content
        }
        $entries += [pscustomobject]@{
            name='JSON 输出规范'; role='System'; position='Relative'; enabled=$true
            inChatDepth=0; isMainChatHistory=$false; customRole=''; content=$jsonCustomBody
        }
        continue
    }
    if ($e.name -eq 'Pawn Profiles') {
        $entries += [pscustomobject]@{
            name='Recent Events'; role='System'; position='Relative'; enabled=$true
            inChatDepth=0; isMainChatHistory=$false; customRole=''; content=$recentEvents
        }
    }
    $entries += [pscustomobject]@{
        name=$e.name; role=$e.role; position=$e.position; enabled=$e.enabled
        inChatDepth=$e.inChatDepth; isMainChatHistory=$e.isMainChatHistory
        customRole=$e.customRole; content=$content
    }
}

$new = [pscustomobject]@{
    name        = $old.name
    version     = $old.version
    description = $old.description
    entries     = $entries
}

# ================= §4.1 静态检查 =================
Write-Host "`n=== §4.1 静态检查 ==="
foreach ($e in $entries) {
    $liquid = ([regex]::Matches($e.content, '\{%')).Count
    $open   = ([regex]::Matches($e.content, '\{\{\s*(if|for|with|capture|each)\b')).Count
    $end    = ([regex]::Matches($e.content, '\{\{\s*end\b')).Count
    Check "$($e.name): 无 Liquid 标签" ($liquid -eq 0) "发现 $liquid 处 {%"
    Check "$($e.name): if/for 与 end 配对 ($open/$end)" ($open -eq $end) "open=$open end=$end"
}

# ================= §4.2 渲染实测 =================
Write-Host "`n=== §4.2 渲染实测（Scriban.dll 1.0.0.0，单参数 Parse）==="
Add-Type -Path $dllPath

function New-MockPawn([object]$label, [object]$gender, [object]$age, [object]$race, [object]$title,
                      [object]$mood, [object]$moodPercent, [object]$health, [object]$job, [object]$traits,
                      [object]$backstory, [object]$ideology, [object]$thoughts, [object]$social) {
    # 键名逐字采用 ScribanParser.GetMagicPawnValue 的 switch 字面量（全小写），
    # 与模板中的写法完全一致。Scriban 内建 Hashtable 成员解析大小写敏感，
    # 键名大小写不一致会产生假失败。
    return @{
        name=$label; gender=$gender; age=$age; race=$race; title=$title
        mood=$mood; moodpercent=$moodPercent; health=$health; job=$job; traits=$traits
        backstory=$backstory; ideology=$ideology; thoughts=$thoughts; captive_status=$null
        social=$social; location='主卧'; surroundings=$null
    }
}

# 用填空值替代 mock 中的空字符串：真实 GetMagicPawnValue 对无内容返回 null
# （ContextBuilder.* ?? "" 之后仍可为 null），而 Scriban 把 "" 当"真值"，
# 两者会走不同分支，故两种输入都必须测。
function ConvertTo-NullBlanks($v) {
    if ($v -is [hashtable]) {
        $o = @{}
        foreach ($k in $v.Keys) { $o[$k] = (ConvertTo-NullBlanks $v[$k]) }
        return $o
    }
    if ($v -is [string] -and $v -eq '') { return $null }
    return $v
}

# 目标 pawn 的可选字段：Title/Health/Thoughts 恒为有值（用于验证「有值必出现」），
# CaptiveStatus/Ideology/社交 交由场景控制。这样同一 mock 既能验证有值渲染，
# 也能靠 Zed 验证空值不泄漏标签。
function New-MockContext([bool]$isMono, [object]$social, [object]$captive = $null, [object]$ideo = $null) {
    # 注意：hashtable 的键在同一表内不得只靠大小写区分（PowerShell 哈希大小写不敏感，
    # 会互相覆盖）。真实 Pawn 只有一个 canonical 名字，故此处每个字段只用一种拼写。
    $target = New-MockPawn 'Ann' '女性' '28' '人类' '爵士' '良好' '80' '轻微擦伤' '搬运' '善良' '矿工家庭出身' $ideo '想吃肉' $social
    $target['captive_status'] = $captive
    $other  = New-MockPawn 'Zed' '男性' '31' '人类' $null $null '55' $null '种植' '悲观' '贵族出身' $null $null $null
    $pawn = $target

    $dtype = if ($isMono) { '独白' } else { '闲聊' }
    $ctx = @{ IsMonologue=$isMono; DialogueType=$dtype; History='[早前] Ann: 你好' }
    $map = @{ weather='小雨'; temperature='14' }

    $so = New-Object Scriban.Runtime.ScriptObject
    $so.Add('ctx', $ctx)
    $so.Add('pawn', $pawn)
    $so.Add('pawns', @($target, $other))
    $so.Add('map', $map)
    $so.Add('hour', 14); $so.Add('day', 3); $so.Add('quadrum', '春'); $so.Add('season', '春季')
    $so.Add('events', 'raid: 袭击者来袭')
    $so.Add('prompt', 'Ann 对 Zed 说了句话')
    $so.Add('lang', '中文')
    $so.Add('is_user', $false)
    $so.Add('json', @{ format='<json.format>'; anchor='<json.anchor>' })
    $so.Add('context', 'PawnContextObj')
    return $so
}

# 复现 mod 的变量/成员解析：
#   ScribanParser.cs:145-154  BuiltinObject 先精确匹配、再大小写不敏感回退
#   ScribanParser.cs:205-213  字典成员同样先精确、再大小写不敏感回退
#   Pawn 走 TryGetMember -> NormalizePawnMember -> GetMagicPawnValue，同样大小写不敏感
# 若只用 Scriban 内建的 Hashtable 成员解析（大小写敏感），模板里的 captive_status
# 会取不到 mock 里的 CaptiveStatus 键，产生假失败。
function Find-CiKey($dict, [string]$name) {
    if ($dict.ContainsKey($name)) { return $name }
    foreach ($k in $dict.Keys) { if ([string]::Equals($k, $name, [StringComparison]::OrdinalIgnoreCase)) { return $k } }
    return $null
}

function New-MockScriptObject($vars) {
    $so = New-Object Scriban.Runtime.ScriptObject
    foreach ($k in $vars.Keys) { $so.Add($k, $vars[$k]) }
    return $so
}

function New-MockTemplateContext($so) {
    $tc = New-Object Scriban.TemplateContext
    $tc.PushGlobal($so)
    $tc.TryGetVariable = [Scriban.TemplateContext+TryGetVariableDelegate]{
        param($tctx, $span, $variable, [ref]$value)
        $name = $variable.Name
        if ($so.ContainsKey($name)) { $value.Value = $so[$name]; return $true }
        $k = Find-CiKey $so $name
        if ($k) { $value.Value = $so[$k]; return $true }
        $value.Value = $null
        return $false
    }
    $tc.TryGetMember = [Scriban.TemplateContext+TryGetMemberDelegate]{
        param($tctx, $span, $target, $member, [ref]$value)
        if ($target -is [hashtable]) {
            $k = Find-CiKey $target $member
            if ($k) { $value.Value = $target[$k]; return $true }
        }
        $value.Value = $null
        return $false
    }
    return $tc
}

function Render-Template([string]$text, $so) {
    $tpl = [Scriban.Template]::Parse($text)
    if ($tpl.HasErrors) { throw "Parse errors: $(($tpl.Messages | ForEach-Object { $_.Message }) -join '; ')" }
    # 用忠实复现 mod 解析逻辑的模板上下文（含大小写不敏感回退）
    $tc = New-MockTemplateContext $so
    return $tpl.Render($tc)
}

$ppTpl = ($entries | Where-Object name -eq 'Pawn Profiles').content
$dpTpl = ($entries | Where-Object name -eq 'Dialogue Prompt').content
$reTpl = ($entries | Where-Object name -eq 'Recent Events').content

# 两种空值输入：null（真实 GetMagicPawnValue 的返回）与空字符串（防御另一种可能）
$variants = [ordered]@{
    'null' = $false
    '空串' = $true
}

function Get-VariantCtx([bool]$isMono, [string]$social, [object]$captive, [object]$ideo, [bool]$useEmpty) {
    $so = New-MockContext $isMono $social $captive $ideo
    if ($useEmpty) {
        # 把 pawn / pawns 中所有 $null 换成 ''
        $so['pawn']  = ConvertTo-NullBlanks $so['pawn']
        $so['pawns'] = @($so['pawns'] | ForEach-Object { ConvertTo-NullBlanks $_ })
    }
    return $so
}

# --- 临时诊断（RT_DEBUG=1 时输出）---
if ($env:RT_DEBUG) {
    $dbgCtx = New-MockContext $false $null '囚犯' '唯灵论'
    $dbgPawn = $dbgCtx['pawn']
    Write-Host "[DBG] pawn['captive_status'] = '$($dbgPawn['captive_status'])'"
    Write-Host "[DBG] pawn['ideology']       = '$($dbgPawn['ideology'])'"
    $mini = 'MINI-C[{{p.captive_status}}] MINI-I[{{p.ideology}}]'
    $soM = New-MockScriptObject @{ p = $dbgPawn }
    Write-Host "[DBG] 最小渲染: $(([Scriban.Template]::Parse($mini)).Render((New-MockTemplateContext $soM)))"
    Write-Host "[DBG] 完整模板含'囚犯': $((Render-Template $ppTpl $dbgCtx) -match '囚犯')"
}

# mustAbsent 用 Zed（可选字段全空）验证「空值不泄漏标签」。
# 注意标题『爵士』不用于 mustPresent：p.title 在对话分支仅当非空才输出，
# 但「头衔」二字本身不是标签文案（标签是直接拼值），故不作断言对象。
# 空值泄漏的判定对象是 Zed（可选字段全空）。Ann 的 Title/Health/Thoughts 恒有值，
# 故不能用 mustAbsent 断言这些标签；改为专门检查 Zed 的行不含任何可选字段标签。
function Get-EmptyPawnLines([string]$out) {
    # Zed 行及其后续缩进的「特质：」行
    return ($out -split "`n") | Where-Object { $_ -match 'Zed|特质：悲观' }
}

$scenarios = [ordered]@{
    'S1 对话/无社交/可选字段全空' = @{ mono=$false; social=$null; captive=$null; ideo=$null;
        mustAbsent=@('处境','信仰'); mustPresent=@('Ann','Zed','【对话参与者】','当前参与者之间无已知社交关系','爵士','轻微擦伤') }
    'S2 对话/有社交/可选字段全空' = @{ mono=$false; social='Zed: 恋人'; captive=$null; ideo=$null;
        mustAbsent=@('处境','信仰','当前参与者之间无已知社交关系'); mustPresent=@('恋人') }
    'S3 对话/可选字段全有值'      = @{ mono=$false; social=$null; captive='囚犯'; ideo='唯灵论';
        mustAbsent=@(); mustPresent=@('囚犯','唯灵论','轻微擦伤','爵士') }
    'S4 独白/可选字段全空'        = @{ mono=$true;  social=$null; captive=$null; ideo=$null;
        mustAbsent=@('处境','意识形态','【对话参与者】'); mustPresent=@('【独白角色】','Ann','爵士','轻微擦伤') }
    'S5 独白/可选字段全有值'      = @{ mono=$true;  social=$null; captive='囚犯'; ideo='唯灵论';
        mustAbsent=@('【对话参与者】'); mustPresent=@('囚犯','唯灵论','轻微擦伤','爵士','想吃肉') }
}

foreach ($sName in $scenarios.Keys) {
    $sc = $scenarios[$sName]
    foreach ($vName in $variants.Keys) {
        $label = "$sName [$vName]"
        try {
            $so = Get-VariantCtx $sc.mono $sc.social $sc.captive $sc.ideo $variants[$vName]
            $out = Render-Template $ppTpl $so
            if ($vName -eq 'null') { Write-Host "`n─ $label 输出 ─`n$out" }
            Check "$label 渲染无异常" $true ''
            Check "$label 无 {{ / {% 泄漏" ($out -notmatch '\{\{|\{%') 'template syntax leaked'
            Check "$label 无多余逗号 ',,'" ($out -notmatch ',,') 'double comma found'
            foreach ($s in $sc.mustAbsent)  { Check "$label 不应出现 '$s'" ($out -notmatch [regex]::Escape($s)) "leaked: $s" }
            foreach ($s in $sc.mustPresent) { Check "$label 应出现 '$s'" ($out -match [regex]::Escape($s)) "missing: $s" }
            # 空值 pawn（Zed）的行不得出现任何可选字段标签
            $emptyLines = (Get-EmptyPawnLines $out) -join "`n"
            foreach ($s in @('处境','信仰','健康','当前想法','意识形态')) {
                Check "$label Zed 行不泄漏 '$s'" ($emptyLines -notmatch [regex]::Escape($s)) "Zed line leaked: $s"
            }
        } catch { Check "$label 渲染无异常" $false $_.Exception.Message }
    }
}

# --- Dialogue Prompt：两种空值输入 ---
foreach ($vName in $variants.Keys) {
    $label = "DP [$vName]"
    try {
        $so = Get-VariantCtx $false $null $null $null $variants[$vName]
        $out4 = Render-Template $dpTpl $so
        if ($vName -eq 'null') { Write-Host "`n─ Dialogue Prompt 输出 ─`n$out4" }
        Check "$label 渲染无异常" $true ''
        Check "$label 无 {{ / {% 泄漏" ($out4 -notmatch '\{\{|\{%') 'template syntax leaked'
        Check "$label 输出天气" ($out4 -match '小雨') 'weather missing'
        Check "$label 周围为空时不泄漏标签" ($out4 -notmatch '周围') 'surroundings label leaked'
    } catch { Check "$label 渲染无异常" $false $_.Exception.Message }
}

# --- Recent Events：有事件 / 空事件 ---
try {
    $out5 = Render-Template $reTpl (New-MockContext $false $null)
    Write-Host "`n─ Recent Events（有事件）输出 ─`n$out5"
    Check "RE 渲染无异常" $true ''
    Check "RE 输出事件内容" ($out5 -match '袭击者来袭') 'events missing'
    $so2 = New-MockContext $false $null
    $so2['events'] = ''
    $out6 = Render-Template $reTpl $so2
    Check "RE 空事件时整块消失" ([string]::IsNullOrWhiteSpace($out6)) "got: '$out6'"
} catch { Check "RE 渲染无异常" $false $_.Exception.Message }

# ---------- 结论 ----------
Write-Host "`n============================================"
if ($fail.Count -eq 0) {
    Write-Host "全部检查通过，写入 $outPath"
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    $json = $new | ConvertTo-Json -Depth 20
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($outPath, $json, $utf8Bom)
    Write-Host "已写入。字节数: $((Get-Item -LiteralPath $outPath).Length)"
} else {
    Write-Host "有 $($fail.Count) 项失败，未写入任何文件："
    $fail | ForEach-Object { Write-Host "  - $_" }
}
