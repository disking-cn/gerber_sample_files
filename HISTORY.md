# HISTORY — gerber_sample_files 治理沿革

- 2026-11-10 AGENTS.md v1 立规（用户拍板三分法）：受控面（bin/files/dataport/images/LICENSE 等，git 双远端）、生成面（gerbers/geoms，SSD 临时件可再生）、金库面（files 64 zip 入 kb-vault `ldi-gerber-corpus`，COPY 归档）。`.gitignore` 解除 `dataport/` 排除，文稿入库受控。
- 已知错位件：`geoms/encoder-rle4k-cpu/`（约 1 MB，C1 编码器产物混入生成目录），待迁出至其论文线，不随生成面清理陪葬。
- 2026-07-24 双远端最后一次同步基线（`524e2ad`）；治理立规前 main 曾领先双远端 1 提交。
