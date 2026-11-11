# AGENTS.md — gerber_sample_files 数据域治理（单源规则）

本仓是 LDI 用 64 套公开 GERBER 样例语料（DIF01–DIF64）的唯一发布仓，唯一远端：
`origin = https://github.com/disking-cn/gerber_sample_files.git`。
Gitee 已全线退役（2026-11-10 用户裁定，gitee remote 已删）。本仓现址（权威目录，四次裁定）：`D:/Projects/dataports/gerber_sample_files`；旧路径 `D:/Projects/gitee/ldi/gerber_sample_files` 已废弃：残留空壳由开机计划任务 `gerber-husk-cleanup` 于下次重启后**彻底删除**，不留 junction（用户裁定）；原钉旧路径的配置（`bin/redtt.json` 等）已同步改至现址，消费者一律使用 `D:/Projects/dataports/gerber_sample_files`。
治理面分三部分，任何目录归类以本文件为准（v2，2026-11-10 用户拍板）。

## 1. 受控面（git / github 单远端管辖）

成员：`bin/`、`files/`、`images/`、`LICENSE`、`README.md`、`cover.png`、`.gitignore`、本文件。

- 权威源 = git（github）；内容变更一律本地 `main` 提交后推送 github。公网推送受外推铁闸约束：本仓的推送授权 = 用户 2026-11-10 明令（github only）。
- `files/` 只收 `*.zip`（64 件，命名 `DIFnn.zip`）；`images/` 只收对应预览 `DIFnn.gbr.png`；`bin/` 收工具与脚本（gbrcli/redcli/redtt/7z + bat + help/json）。
- 大文件红线：GitHub 单文件 100 MB 软上限，新增 zip 超限一律先议，不得硬塞。
- IEEE DataPort 投稿文稿**不在仓内**（2026-11-10 二次裁定移出）：归 `D:/Projects/dataports/gerber-sample-files/` 域，该域 README 记录对外提供内容；实体 zip 仍由本仓 `files/` 管辖，dataports 侧仅 junction 指针。

## 2. 生成面（临时件，SSD，可再生禁受控）

成员（**住仓上一级 dataports 域根，七次裁定 2026-11-10**）：`D:/Projects/dataports/gerbers/`（`files/*.zip` 经 7z 解出的 `*.gbr`，约 3.6 GB）与 `D:/Projects/dataports/geoms/samples/m0/`（经 `bin/gbrcli --mode batch` 生成的 `*.dif`，64 件，约 17 GB；`samples/m1/`=OPC3 合并金标，非本仓产物，见 `geoms/samples/README.md`）。仓内不留生成物，连 junction 都不留。

- 性质：**算法入口的生成物，不是数据资产**。随时可整目录删除后再生；再生链：`bin/01-unzip-and-convert-to-dif.bat`（7z 解包 → gbrcli 批量转换，直出 `..\..\geoms\samples\m0`，无中转目录——results 旧错位口径自七次裁定废止）。
- 放置：必须位于 SSD（消费方是 redcli/redtt 等算法的效率敏感入口）。本机 D 盘即 SATA SSD（GLOWAY 4 TB），**现址已满足**；如需更高吞吐可迁 NVMe（F 盘）并在仓内原址留目录 junction 保持入口路径不变，迁移属可逆动作，AGENTS 不需改。
- 红线：生成物永不入 git（现居仓外天然满足；`.gitignore` 的 `geoms/`、`gerbers/` 条目留作双保险）；语料性/论文性产物**禁存 `geoms/` 内**。历史上误入的 `geoms/encoder-rle4k-cpu`（2,426 B，Everything 目录列表页 HTML 残渣，2026-08-07 误存，非数据件）已于 2026-11-10 删除，详见 HISTORY 勘误。

## 3. 金库面（kb-vault 登记，指针不落字节）

`files/` 64 件 zip 登记入 kb-vault 实验数据域（project `ldi-gerber-corpus`，台账 `catalog/kb_catalog.db` 表 `exp_batch`）。登记形态（2026-11-10 用户裁定，取代 v1 的 COPY 归档）：**不拷贝**，馆内批次目录只放 `files` 目录 LINK（junction → 仓内 `files/`）+ `README.md` 说明件（指向 GitHub 仓与本地路径）+ `MANIFEST.sha256` 逐件哈希。

- 语义 = **指针登记**：仓内 `files/` 是唯一实体，馆内零字节副本；对账靠逐件 sha256（`kb_data.py verify` 经 junction 穿透复核）。
- 登记入口：`scripts/kb_link.py link-register`（源目录零搬动）。
- 网盘注意：kb-vault 本体在百度网盘（BaiduSyncdisk）内。若网盘穿透跟随 junction，会把 ~706 MB 上传——首次登记后须在网盘侧核验 LINK 未被穿透（待测）；若穿透，在网盘同步排除中排除该 LINK。
- 版本锚：金库批次以 git tag 记锚（内容冻结 = tag，金库不随 commit 滚动追打）。金库侧只进不改；语料扩充先在仓内定版（tag），再开新批次登记新指针。

## 指针

- 仓用途与文件清单：`README.md`；许可与使用边界：`LICENSE`。
- 金库规程：`E:/BaiduSyncdisk/kb-vault/README.md` 与 `scripts/kb_data.py`/`scripts/kb_link.py` 文件头红线；指针登记用 `kb_link.py link-register`。
- 沿革：`HISTORY.md`。
