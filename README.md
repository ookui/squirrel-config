# Squirrel 配置

本机鼠须管配置快照，基于雾凇拼音，包含万象 LTS 语法补丁和自定义外观。
首次同步日期：2026-11-09。

## 同步范围

保留 YAML 配置、全拼和双拼方案、中英文词库、自定义短语、A 股词库、Lua 脚本及 OpenCC 文件。
当前自定义设置包括每页 9 个候选词，以及随系统切换的浅色和深色外观。

以下内容留在本机：`build/` 编译产物、`*.userdb/` 用户词频数据库、
`sync/` 同步快照、`installation.yaml` 设备信息、`user.yaml` 运行状态、
外观备份目录和 `*.gram` 语法模型。

雾凇拼音原说明保存在 [README.rime-ice.md](README.rime-ice.md)，上游项目为
[iDvel/rime-ice](https://github.com/iDvel/rime-ice)。原有许可证文件随配置保留。

## 本机配置更新后同步到 GitHub

独立工作副本位于 `~/projects/squirrel-config`，输入法实际读取 `~/Library/Rime`。

```bash
cd ~/projects/squirrel-config
git pull --ff-only
bash scripts/sync-from-rime.sh
git diff --stat
git add -A
git diff --cached --stat
git commit -m "Update Squirrel configuration"
git push origin main
```

没有变更时，跳过提交和推送。可先运行
`bash scripts/sync-from-rime.sh --dry-run` 预览复制及删除操作。
脚本以本机配置为准更新工作副本，也会删除工作副本中已从本机移除的配置文件；
仓库文档、同步脚本、Git 元数据和忽略项受保护。脚本本身不提交或推送。
自定义来源可使用 `RIME_DIR=/path/to/Rime bash scripts/sync-from-rime.sh`。

`~/Library/Rime` 内已有的旧 `.git` 未改动。后续提交和推送均在独立工作副本执行。

## 换电脑恢复

1. 安装鼠须管，并确认其引擎支持 Octagram 语法模型。
2. 克隆本仓库；若目标电脑已有配置，先完整备份 `~/Library/Rime`。
3. 将方案和词库复制到 Rime 用户目录：

   ```bash
   mkdir -p ~/Library/Rime
   rsync -av \
     --exclude='.git/' \
     --exclude='.gitignore' \
     --exclude='README.md' \
     --exclude='README.rime-ice.md' \
     --exclude='scripts/' \
     --exclude='docs/' \
     ~/projects/squirrel-config/ ~/Library/Rime/
   ```

4. 从[万象官方 LTS 发布页](https://github.com/amzxyz/rime-wanxiang-data/releases/tag/LTS)
   下载 `wanxiang-lts-zh-hans.gram`，放入 `~/Library/Rime/`。
5. 在鼠须管菜单中选择“重新部署”，再选用雾凇拼音或所需双拼方案。

本仓库不包含个人学习词频。恢复后，词频由目标电脑重新学习。

## 万象模型版本记录

本次同步保留了本机已使用的模型，模型文件未上传：

- 文件：`wanxiang-lts-zh-hans.gram`
- 大小：418,078,764 字节
- SHA-256：`e34500ab44626dc039a0641792ecba98ab63307646eb3d29186be56608ffe094`

2026-11-09 查询时，官方 LTS 发布资产已更新，大小为 418,080,812 字节，
SHA-256 为 `769854c83f6c914a05a1e1abb67c31c00f1ae622a41878e05957bcdee3dbda9a`。
因此从发布页下载的模型与本次记录的本机版本不同；若要完整复现本机版本，
请保留并复制上述本机模型文件。可用 `shasum -a 256` 检查文件。
