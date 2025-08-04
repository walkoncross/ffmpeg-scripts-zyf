import os


def find_common_files(input_folders):
    """
    找出所有输入文件夹中共同存在的同名文件

    参数:
    input_folders (list): 包含文件夹路径的列表

    返回:
    list: 所有文件夹中共同存在的文件名列表
    """
    # 检查输入文件夹列表是否为空
    if not input_folders:
        return []

    # 存储第一个文件夹中的所有文件名
    common_files = set()
    first_folder = input_folders[0]

    # 确保路径存在且是文件夹
    if not os.path.isdir(first_folder):
        raise ValueError(f"路径 '{first_folder}' 不是有效的文件夹")

    # 获取第一个文件夹中的所有文件
    for entry in os.listdir(first_folder):
        entry_path = os.path.join(first_folder, entry)
        if os.path.isfile(entry_path):
            common_files.add(entry)

    # 如果第一个文件夹中没有文件，直接返回空列表
    if not common_files:
        return []

    # 遍历其他文件夹，计算交集
    for folder in input_folders[1:]:
        # 确保路径存在且是文件夹
        if not os.path.isdir(folder):
            raise ValueError(f"路径 '{folder}' 不是有效的文件夹")

        current_files = set()
        for entry in os.listdir(folder):
            entry_path = os.path.join(folder, entry)
            if os.path.isfile(entry_path):
                current_files.add(entry)

        # 计算交集
        common_files.intersection_update(current_files)

        # 如果交集为空，提前返回
        if not common_files:
            return []

    # 转换为列表并返回
    return sorted(list(common_files))


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="找出多个文件夹中共同存在的文件")
    parser.add_argument(
        "input_folders",
        nargs="+",
        help="输入文件夹路径列表",
    )
    parser.add_argument(
        "-o",
        "--output_file",
        default="common_files.txt",
        help="输出文件路径",
    )

    args = parser.parse_args()
    print(f"--> args: {args}")

    common_files = find_common_files(args.input_folders)
    print("--> 共同存在的文件:", common_files)

    # 将共同存在的文件写入输出文件
    with open(args.output_file, "w") as f:
        for file in common_files:
            f.write(file + "\n")

    print(f"--> 共同存在的文件已写入 {args.output_file}")

    sh_path = os.path.join(os.path.dirname(__file__), "hstack_3_videos.sh")
    print(f"--> sh_path: {sh_path}")

    for ii, file in enumerate(common_files):
        print(f"--> 处理文件 {ii}/{len(common_files)}: {file}")
        full_path_list = []
        for folder in args.input_folders:
            full_path_list.append(os.path.join(folder, file))
        
        output_path = os.path.join(os.path.dirname(args.output_file), f"{os.path.splitext(file)[0]}-hstacked.mp4")
        cmd = f"{sh_path} {' '.join(full_path_list)} {output_path}"
        print(f"--> 执行命令: {cmd}")
        os.system(cmd)

