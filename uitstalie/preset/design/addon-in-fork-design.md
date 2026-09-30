# 仓库内附加 Mod 设计（决策稿）

> 状态：**设计已定，未写代码**
> 用户决策：**附加 mod 放进 fork 仓库内，与上游代码隔离**
> 用户约束：**尽量保持对上游兼容**
> 关联：`../TODO.md` D2 · `source-enhancement-design.md`（候选清单）

---

## 1. 关键约束（已实测）

| 事实 | 影响 |
|---|---|
| `RimTalk.csproj` 是 **SDK 风格 + 默认 glob**，仅 `Compile Remove="Tests/**"` | `Source/**` 下**新增 `.cs` 会被自动编入主 mod** —— 必须隔离 |
| 上游 `.gitignore` 已含 `AGENTS.md` / `CLAUDE.md` / `Docs/*` | 上游刻意不跟踪代理文档；我们的目录不能被意外忽略 |
| `obj/` `bin/` 已在 `.gitignore` | 构建产物不会误提交 |
| 部署段用 `robocopy`/`rsync` 按 `About;Defs;Languages;Textures;$(GameVersion)` 白名单 | 部署只搬这几个目录，**不会**误搬我们的目录 |
| 项目 `net48`，`PackageReference` 含 `Krafs.Rimworld.Ref`、`Lib.Harmony.Ref` | 附加项目可复用同一套参考，无需游戏本体 |

---

## 2. 目录布局

```
RimTalk-uitstalie/                    ← 仓库根
├── About/ Defs/ Languages/ Libs/      ← 上游原件，不动
│   Source/ Tests/ Textures/ …             （Source/** 新文件会被自动编入，勿放）
├── RimTalk.csproj                     ← 上游项目，不动
│
└── uitstalie/                         ★ 我们的隔离区
    ├── README.md                      说明这个目录是什么、怎么构建
    ├── RimTalk.Uitstalie.csproj       独立项目，独立 AssemblyName
    ├── Source/                        附加 mod 的 C# 代码
    ├── About/About.xml                独立 mod 元数据（独立 packageId！）
    ├── Languages/                     本地化
    │
    ├── preset/                        ★ 预设与设计文档
    │   ├── DeepSeek Chat_preset.json
    │   ├── README.md
    │   ├── preset_diff.md
    │   └── design/                    从工作区同步过来的研究文档
    │
    └── tools/                         验证脚本（PowerShell）
        └── build_preset.ps1
```

**隔离原理**：上游 `csproj` 的 glob 从**仓库根**递归，`uitstalie/**` 里的 `.cs`
**也会被主项目扫到** —— 这是必须处理的点。解决方案见 §3。

---

## 3. 必须解决的问题：glob 会吞掉我们的源码

上游 `RimTalk.csproj` 没有 `EnableDefaultCompileItems=false`，故默认含
`**/*.cs`。若把 `.cs` 放在 `uitstalie/Source/`，**会被编进 RimTalk.dll**。

两个做法：

### 方案 A：在附加项目的 csproj 里 `Compile Remove`（改上游一行）

```xml
<!-- 在 RimTalk.csproj 中新增 -->
<Compile Remove="uitstalie/**" />
<None Include="uitstalie/**" />
```

- 优点：简单、明确
- 缺点：**改了上游文件**，同步上游时可能冲突（1 行，冲突概率低）

### 方案 B：附加源代码放到仓库根 glob 之外

把附加项目挪到**仓库外**（如 `code/RimTalk-Uitstalie/`）—— 但这与
"放进 fork 仓库"的用户决策矛盾。

### 方案 C：附加项目不放在 `uitstalie/`，而是放进上游已排除的位置

上游已 `Compile Remove="Tests/**"`，但借用 `Tests/` 语义混乱，不可取。

**建议：方案 A。** 改动仅 2 行，语义清晰，冲突面最小。
若希望零改上游，可选方案 B（但违背用户决策）。

---

## 4. 附加项目配置要点

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net48</TargetFramework>
    <AssemblyName>RimTalk.Uitstalie</AssemblyName>   <!-- 独立程序集 -->
    <RootNamespace>RimTalk.Uitstalie</RootNamespace>
    <LangVersion>default</LangVersion>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Lib.Harmony.Ref" Version="2.*" PrivateAssets="All"/>
    <PackageReference Include="Krafs.Rimworld.Ref" Version="$(GameVersion).*-*" PrivateAssets="All"/>
    <Reference Include="Assembly-CSharp">
      <HintPath>$(RimWorldDir)\RimWorldWin64_Data\Managed\Assembly-CSharp.dll</HintPath>
      <Private>false</Private>
    </Reference>
    <!-- 引用 RimTalk 本体；Private=false 避免随包分发 -->
    <Reference Include="RimTalk">
      <HintPath>..\$(GameVersion)\Assemblies\RimTalk.dll</HintPath>
      <Private>false</Private>
    </Reference>
  </ItemGroup>
</Project>
```

**待定项**：`RimTalk.dll` 的引用路径需按上游实际输出位置核实
（上游部署段指向 `$(WinModPath)$(GameVersion)\Assemblies\`）。

---

## 5. 两个独立 `About.xml` 的关键问题

按 RimWorld 规范，一个 mod 目录 = 一个 `About.xml` = 一个 `packageId`。

- 上游：`About/About.xml`（packageId 应为 `cj.rimtalk`，需核实）
- 我们：`uitstalie/About/About.xml`（**必须用不同 packageId**，如 `uitstalie.rimtalk.enhance`）

**必须确认的依赖声明**：我们的 mod 要声明依赖 RimTalk，
否则加载顺序不保证、`RimTalkPromptAPI` 可能尚未注册。

**风险**：若两者被当成**同一个 mod**（同 packageId），RimWorld 会报冲突。
故 packageId 必须独立。

---

## 6. 内部 API 直调 vs 外部 API —— 一个关键分水岭

用户选了"放进仓库"，这带来一个**上游外部 mod 做不到的能力**：
附加代码可以**编译进 RimTalk 程序集**（方案 A 的反面），从而**进程内直调**。

| 能力 | 外部 API（独立程序集） | 内部直调（编入 RimTalk.dll） |
|---|---|---|
| `RegisterPawnVariable` 等公开 API | ✅ | ✅ |
| 绕过 `MemberFilter`（解锁遮蔽子树） | ❌ | ✅ |
| 修空串真值（`?? ""` → `?? null`） | ❌ | ✅ |
| 改 `PromptPresetAssembler` 行为 | ❌ | ✅ |
| 上游兼容 | ✅ 完全 | ❌ 破坏 |
| 部署 | 独立 mod 包 | 需整包替换 RimTalk |

**注意矛盾**：候选 1（空串真值）与候选 2（遮蔽解除）**必须内部直调**才能做，
而这两条正是"保持上游兼容"下做不了的。用户同时选了"兼容"与"放进仓库"，
但这两者在**候选 1/2 上冲突**：

- 走外部 API → 兼容，但候选 1/2 永久做不了
- 走内部直调 → 候选 1/2 能做，但破坏兼容，且部署变为整包替换

**这不是二选一到底的问题**，可以**分层**：
- 能用外部 API 的（候选 3/4/6）→ 独立程序集
- 必须内部直调的（候选 1/2）→ 单独评估，或改用"并存新增变量"绕过

---

## 7. 推荐的分层架构

```
uitstalie/
├── Source/           外部扩展（独立程序集 RimTalk.Uitstalie.dll）
│                     用 RimTalkPromptAPI 注册新变量 → 天然兼容
│
│  若日后确需内部改动（候选 1/2），再另开一支：
└── (预留) 内部改动方案文档，先设计不实施
```

**理由**：先用外部 API 拿到大部分收益（候选 3/4/6 都是纯新增），
把有兼容代价的部分（候选 1/2）推迟到有真实运行数据之后。

---

## 8. 待办

1. 核实上游 `About/About.xml` 的 packageId，确定我们的新 packageId
2. 核实 `RimTalk.dll` 的构建输出路径，写准 `<HintPath>`
3. 决定方案 A（改上游 2 行 glob）还是方案 B（放仓库外）
4. 明确 `GameVersion` 属性取值（上游 csproj 用了 `$(GameVersion)`，需看默认值）
5. 决定预设/文档目录是否也纳入本仓库（用户意向是纳入）
