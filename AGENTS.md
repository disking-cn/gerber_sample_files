# AGENTS.md — gerber_sample_files 数据域治理（单源规则）

本仓是 LDI 用 64 套公开 GERBER 样例语料（DIF01–DIF64）的唯一发布仓，双远端：
`origin = https://gitee.com/disking-cn/gerber_sample_files.git`、`github = https://github.com/disking-cn/gerber_sample_files.git`。
治理面分三部分，任何目录归类以本文件为准（2026-11-10 用户拍板）。

## 1. 受控面（git 双远端管辖）

成员：`bin/`、`files/`、`dataport/`、`images/`、`LICENSE`、`README.md`、`cover.png`、`.gitignore`、本文件。

- 权威源 = git 双远端；内容变更一律本地 `main` 提交后 **双推**（origin 与 github 都要推，缺一即视为未发布）。
- `files/` 只收 `*.zip`（64 件，命名 `DIFnn.zip`）；`images/` 只收对应预览 `DIFnn.gbr.png`；`bin/` 收工具与脚本（gbrcli/redcli/redtt/7z + bat + help/json）。
- 大文件红线：Gitee 单文件 100 MB 上限，新增 zip 超 100 MB 一律先议，不得硬塞。
- `dataport/`（IEEE DataPort 投稿文稿）属受控文档面（2026-11-10 拍板，自本版本起解除 ignore 入库）。

## 2. 生成面（临时件，SSD，可再生禁受控）

成员：`gerbers/`（`files/*.zip` 经 7z 解出的 `*.gbr`，约 3.6 GB）与 `geoms/`（`gerbers/*.gbr` 经 `bin/gbrcli --mode batch` 生成的 `*.dif`，约 16.5 GB）。

- 性质：**算法入口的生成物，不是数据资产**。随时可整目录删除后再生；再生链：
  `bin/01-unzip-and-convert-to-dif.bat`（7z 解包 → gbrcli 批量转换；注意脚本输出目录为 `results/`，`geoms/` 为实际使用的成品目录，转换后按现行惯例归位）。
- 放置：必须位于 SSD（消费方是 redcli/redtt 等算法的效率敏感入口）。本机 D 盘即 SATA SSD（GLOWAY 4 TB），**现址已满足**；如需更高吞吐可迁 NVMe（F 盘）并在仓内原址留目录 junction 保持入口路径不变，迁移属可逆动作，AGENTS 不需改。
- 红线：`gerbers/`、`geoms/`、`results/` 永不入 git（ignore 已设）；语料性/论文性产物**禁存 `geoms/` 内**（现存 `geoms/encoder-rle4k-cpu/` 为错位件，待迁出——见 HISTORY）。

## 3. 金库面（kb-vault 登记，私有备份）

`files/` 64 件 zip 同时登记入 kb-vault 实验数据域（project `ldi-gerber-corpus`，经 `scripts/kb_data.py` 台账 `catalog/kb_catalog.db` 表 `exp_batch`）。

- 语义 = **COPY 归档**（区别于 kb_data 默认 MOVE）：仓内 `files/` 为公开发布面，馆内为私有备份面，两面对账靠逐件 sha256（馆内 `MANIFEST.sha256` ↔ git 内容的 tag 锚点）。
- 版本锚：金库批次以 git tag 记 SHA；内容冻结 = tag，金库不随 commit 滚动追打，定版一批登记一批。
- 金库侧只进不改；语料扩充先在仓内定版（tag），再入馆开新批。

## 指针

- 仓用途与文件清单：`README.md`；许可与使用边界：`LICENSE`。
- 金库规程：`E:/BaiduSyncdisk/kb-vault/README.md` 与 `scripts/kb_data.py` 文件头红线。
- 沿革：`HISTORY.md`。
