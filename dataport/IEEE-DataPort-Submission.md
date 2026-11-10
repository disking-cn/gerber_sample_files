# IEEE DataPort 数据集提交物 (Submission Package)

本文件为向 **IEEE DataPort** 提交数据集 `gerber_sample_files` 所需的元数据与文档。

**本地数据根目录：** `D:\Projects\gitee\ldi\gerber_sample_files`  
本次提交**仅包含** `files/` 目录下的 64 个 ZIP 压缩包（每个内含一份 Gerber RS-274X 源文件 `*.gbr`）；`geoms/`、`gerbers/`、`images/` 均为衍生生成物，**不随数据集提供**。

公开镜像（便于下载与更新，优先于 DataPort 使用）：
- GitHub: https://github.com/disking-cn/gerber_sample_files

---

## A. IEEE DataPort 提交表单字段（可直接复制填写）

**1. Dataset Title**
> Gerber Sample Files Dataset: 64 Compressed PCB Gerber (RS-274X) Files

**2. Dataset Authors**
> Qingping Yu, Information Materials and Intelligent Sensing Laboratory of Anhui Province, Anhui University, No. 111 Jiulong Road, Economic and Technological Development Area, Hefei 230601, China
> Zhijia Hu, Key Laboratory of Opto-Electronic Information Acquisition and Manipulation, Ministry of Education, Anhui University, No. 111 Jiulong Road, Economic and Technological Development Area, Hefei 230601, China

**3. Corresponding Author**
> Zhijia Hu — zhijiahu@ahu.edu.cn

**4. Abstract**（英文，< 2000 字符）
> This dataset provides 64 compressed PCB (printed circuit board) Gerber files for technical demonstration, algorithm development, and educational research. Each archive contains a single Gerber file in the RS-274X format (`.gbr`), following the RS-274X specification with aperture macros (AMA) and metric units. The files cover a variety of pad, trace, and macro shapes representative of realistic PCB layouts. All files are generic, synthetically generated test data and contain no customer proprietary information, real product designs, or commercial content. The dataset is suitable for evaluating Gerber parsers, EDA/PCB design tools, geometry extraction algorithms, and computer-vision or machine-learning methods for PCB inspection and recognition. It also supports reproducible experiments on lossless compression and real-time data-path processing for maskless lithography workflows (e.g., the companion RLE4K study). Total size is approximately 705 MB. The files are released under the MIT License for non-commercial research and educational use only. Canonical repository: https://github.com/disking-cn/gerber_sample_files.

**5. Keywords**（≤ 8，逗号分隔）
> Gerber, RS-274X, PCB, printed circuit board, EDA, dataset, computer-aided design, design for manufacturing

**6. Acknowledgements**（可选）
> The authors thank Anhui Dishikun Optoelectronics Technology Co., Ltd. for supporting layout preparation and related tooling used to curate this sample set.

**7. Conflict of Interest Statement**（必填）
> The authors declare that they have no conflicts of interest related to this dataset submission, other than the collaboration acknowledged above, which did not affect the objectivity of sample selection or documentation.

**8. Dataset Characteristics**
- **Dataset Type:** Dataset
- **Data Type:** Text (Gerber RS-274X source, ASCII)
- **Data Format:** ZIP archive; each archive contains one `.gbr` file
- **Size:** ~705 MB (64 files; average ~11 MB/file)
- **Number of Files:** 64 (`DIF01.zip` … `DIF64.zip` under `files/`)
- **Local path (for packaging):** `D:\Projects\gitee\ldi\gerber_sample_files\files`
- **License:** MIT License (research/educational, non-commercial)

**9. Subject Area**（请选择 IEEE DataPort 一级领域）
> Engineering → Electrical & Electronic Engineering
> (备选/二级：Computer Science → Computer-Aided Engineering)

**10. Instructions**（如何使用 / 获取后处理工具）
> The dataset contains only the compressed Gerber source files. To use them, download the ZIP archives from this record (or from the GitHub mirror below) and extract the enclosed `*.gbr` files — no installation or configuration is required. For downstream post-processing (e.g., generating intermediate geometry descriptions or rendered preview images), obtain the post-processing tools and any updated sample packages from the project's source repositories:
> - GitHub: https://github.com/disking-cn/gerber_sample_files

---

## B. 数据集内 README（建议放入上传包根目录，命名为 `README.md`）

```markdown
# Gerber Sample Files Dataset

This dataset contains 64 compressed PCB Gerber files for technical
demonstration, algorithm development, and educational research.

## Authors
- Qingping Yu — Information Materials and Intelligent Sensing Laboratory
  of Anhui Province, Anhui University, No. 111 Jiulong Road, Economic and
  Technological Development Area, Hefei 230601, China
  (E-mail: yuqp@stu.ahu.edu.cn)
- Zhijia Hu (corresponding author) — Key Laboratory of Opto-Electronic
  Information Acquisition and Manipulation, Ministry of Education,
  Anhui University, No. 111 Jiulong Road, Economic and Technological
  Development Area, Hefei 230601, China
  (E-mail: zhijiahu@ahu.edu.cn)

## Contents
- 64 ZIP archives (`DIF01.zip` … `DIF64.zip`), each containing a single
  Gerber RS-274X source file (`*.gbr`).
- Total size: ~705 MB. Average ~11 MB per archive.

## Format
- Gerber files follow the RS-274X specification (aperture macros AMA,
  metric units).
- The files are generic, synthetically generated test data and contain
  no customer proprietary information or real product designs.

## Usage Restrictions
1. Research and educational use only.
2. Commercial use is prohibited.
3. Illegal use is prohibited.

## Instructions
- Download and extract the ZIP archives to obtain the Gerber `*.gbr`
  files; they can be opened directly by any RS-274X-compatible viewer
  or EDA tool.
- Preferred mirrors for updates and tooling:
  - GitHub: https://github.com/disking-cn/gerber_sample_files

## License
Released under the MIT License, subject to the above usage restrictions.
```

---

## C. 提交流程提醒
1. 从 `D:\Projects\gitee\ldi\gerber_sample_files\files\` 取全部 64 个 ZIP（`DIF01.zip`–`DIF64.zip`）作为上传内容；可将该目录再压成一个顶层 ZIP，或直接上传 64 个文件。
2. 将上方 **B** 节的 `README.md` 放入上传包根目录。
3. 在 IEEE DataPort 提交页面逐项粘贴 **A** 节字段，上传数据集包。
4. 提交后 IEEE DataPort 会自动分配 DOI；论文与日常复现请优先引用/使用 GitHub 镜像（Gitee 已于 2026-11 退役）。
