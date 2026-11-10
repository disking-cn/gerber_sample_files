# HISTORY — gerber_sample_files 治理沿革

- 2026-11-10 AGENTS.md v1 立规（用户拍板三分法）：受控面（bin/files/dataport/images/LICENSE 等，git 双远端）、生成面（gerbers/geoms，SSD 临时件可再生）、金库面（files 64 zip 入 kb-vault `ldi-gerber-corpus`，COPY 归档）。`.gitignore` 解除 `dataport/` 排除，文稿入库受控。
- 已知错位件：`geoms/encoder-rle4k-cpu/`（约 1 MB，C1 编码器产物混入生成目录），待迁出至其论文线，不随生成面清理陪葬。
- 2026-07-24 双远端最后一次同步基线（`524e2ad`）；治理立规前 main 曾领先双远端 1 提交。
- 2026-11-10 AGENTS.md v2（用户裁定）：① **gitee 全线退役**——删除 gitee remote，唯一远端 github，"双推"规程废止；② 金库面由 COPY 归档改为**指针登记**：不拷贝，馆内只放 junction（→仓内 `files/`）+ README 指向件 + MANIFEST.sha256，登记入口 `kb_data.py link-register`；③ 勘误：v1 所记错位件 `geoms/encoder-rle4k-cpu` "约 1 MB，C1 编码器产物"**描述有误**——实测为 2,426 B 的 Everything 目录列表页 HTML 存盘残渣（内容含 `d:\Projects\papers\ws-encoder-rle4k-cpu` 列举行，2026-08-07 误存），非数据件，随 v2 清理删除。
- 2026-11-10 三次裁定：建 `D:/Projects/dataports` 数据集投稿物域，`dataport/` 文稿自仓内移出至 `D:/Projects/dataports/gerber-sample-files/`，域内 README 记录 DataPort 提供内容（64 zip + 数据集 README，不含 geoms/gerbers/images/bin）；实体零复制，junction → 仓内 `files/`。
