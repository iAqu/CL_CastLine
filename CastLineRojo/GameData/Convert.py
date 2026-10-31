# 执行命令：python3 -u ./Convert.py

import os
import openpyxl
from enum import Enum

# 定义枚举，每个表单对应一个 WeaponConfig 名称
class ConfigName(Enum):
    WeaponsDataLeft = "WeaponConfig"
    WeaponsDataRight = "WeaponConfig"
    WeaponsData = "WeaponConfig"
    PetsData = "PetConfig"
    AreasData = "AreaConfig"
    EggsData = "EggConfig"
    EnemiesData = "EnemyConfig"
    RebirthData = "RebirthConfig"
    PurchaseData = "PurchaseConfig"
    CodesData = "CodeConfig"
    BossData = "BossConfig"
    OnlineRewardsData = "OnlineRewardConfig"
    DailyRewardsData = "DailyRewardConfig"
    GreatSwordUpgradesData = "GreatSwordUpgradeConfig"
    UpgradesData = "UpgradeConfig"
    GiftBoxesData = "GiftBoxConfig"
    UgcData = "UgcConfig"
    AchievementsData = "AchievementConfig"
    SeasonQuestsData = "SeasonQuestConfig"
    SeasonRewardsData = "SeasonRewardConfig"
    SpeedUpData = "SpeedUpConfig"
    HorsesData = "HorseConfig"
    ItemsData = "ItemConfig"
    RebirthUpgradesData = "RebirthUpgradesConfig"
    LongDailyRewardsData = "LongDailyRewardConfig"
    QuestsData = "QuestConfig"
    FruitsData = "FruitConfig"
    LimitedPacksData = "LimitedPackConfig"
    DungeonEnemiesData = "DungeonEnemyConfig"
    PrincessesData = "PrincessConfig"
    DungeonShopData = "DungeonShopConfig"
    TracksData = "TrackConfig"
    TreadmillsData = "TreadmillConfig"
    ChristmasShopData = "ChristmasShopConfig"
    ChristmasDailyRewardsData = "ChristmasDailyRewardConfig"
    ValentineDailyRewardsData = "ValentineDailyRewardConfig"
    FruitShopData = "FruitShopConfig"
    HatsData = "HatConfig"
    JurassicShopData = "JurassicShopConfig"
    HareDailyRewardsData = "HareDailyRewardConfig"
    HalloweenDailyRewardsData = "HalloweenDailyRewardConfig"
    AnvilsData = "AnvilConfig"
    BodySizesData = "BodySizeConfig"
    ClothesData = "ClothConfig"
    StorePacksData = "StorePackConfig"
    # 添加更多的表单和对应的 WeaponConfig 名称

def setup_sheet_name_completion(sheet_names):
    try:
        import readline
    except ImportError:
        return

    def completer(text, state):
        matches = [
            sheet_name
            for sheet_name in sheet_names
            if sheet_name.lower().startswith(text.lower())
        ]
        if state < len(matches):
            return matches[state]
        return None

    readline.set_completer(completer)
    if "libedit" in (readline.__doc__ or "").lower():
        readline.parse_and_bind("bind ^I rl_complete")
    else:
        readline.parse_and_bind("tab: complete")


def resolve_sheet_choice(choice, sheet_names):
    if not choice:
        return None, []

    if choice in sheet_names:
        return choice, []

    try:
        choice_index = int(choice) - 1
        if 0 <= choice_index < len(sheet_names):
            return sheet_names[choice_index], []
    except ValueError:
        pass

    matches = [
        sheet_name
        for sheet_name in sheet_names
        if sheet_name.lower().startswith(choice.lower())
    ]
    if len(matches) == 1:
        return matches[0], []

    return None, matches


def select_sheet_name(sheet_names):
    setup_sheet_name_completion(sheet_names)

    while True:
        choice = input(
            "请选择要导出的表格（输入编号 / 表名前缀 / 完整表名；Tab 补全；q 退出）:"
        ).strip()
        if choice.lower() == "q":
            return None

        selected_sheet_name, matches = resolve_sheet_choice(choice, sheet_names)
        if selected_sheet_name is not None:
            return selected_sheet_name

        if len(matches) > 1:
            print("匹配到多个表格，请继续输入更多前缀或按 Tab 补全：")
            for sheet_name in matches:
                print(f"  - {sheet_name}")
        else:
            print("无效的输入，请重新输入。")


def main():
    # 打开Excel文件
    workbook_path = os.environ.get("GAME_DATA_XLSX", "GameData.xlsx")
    workbook = openpyxl.load_workbook(workbook_path, data_only=True)

    # 获取所有表格名称
    sheet_names = workbook.sheetnames

    # 打印所有表格名称
    print("可用表格：")
    for i, sheet_name in enumerate(sheet_names):
        print(f"{i+1}. {sheet_name}")

    # 让用户选择要导出的表格
    selected_sheet_name = select_sheet_name(sheet_names)

    # 如果用户选择了表格，则导出该表格的数据
    if selected_sheet_name is None:
        return

    selected_sheet = workbook[selected_sheet_name]
    rows_list = list(selected_sheet.rows)

    header_row = rows_list[0]
    header = [cell.value for cell in header_row]

    second_row = rows_list[1]  # 获取第二行

    data_types = {header[i]: second_row[i].value for i in range(len(header)) if second_row[i].value is not None}  # 排除空列
    rows = [[cell.value for cell in row] for row in selected_sheet.rows]

    rows_data = []
    # for row in rows[2:]:  # 从第三行开始导出数据
    for row in rows[3:]:  # 从第四行开始导出数据
        row_data = {}
        for i, value in enumerate(row):
            row_data[header[i]] = value if value is not None else None  # 将空单元格的值替换为 None
        if any(row_data.values()) and not all(value is None for value in row_data.values()):  # 排除全部为 None 的行数据
            rows_data.append(row_data.copy())  # 创建字典的副本，并将其添加到列表中

    output_folder = os.path.join("..", "src", "ReplicatedFirst", "Data")

    config_name = ConfigName[selected_sheet_name].value  # 根据表单名称获取对应的 WeaponConfig 名称
    output_filename = f"{selected_sheet_name}.lua"
    output_path = os.path.join(output_folder, output_filename)

    with open(output_path, "w") as f:
        f.write(f"export type {config_name} = {{\n")
        for key, value in data_types.items():
            f.write(f"    {key}: {value},\n")
        f.write("}\n\n")

        f.write(f"local {selected_sheet_name}: {{[string]: {config_name}}} = {{\n")
        for row_data in rows_data:
            first_column_value = row_data[header[0]]  # 获取第一列的值作为键名
            f.write(f"    {first_column_value} = {{\n")
            
            for key, value in row_data.items():
                if value is not None:

                    if data_types[key] == 'string':
                        value = f'"{value}"'

                    elif data_types[key] == 'table':
                        value = f"{{{value}}}"

                    elif data_types[key] == 'number' and isinstance(value, float):
                        value = f"{value:.2f}"  # 保留二位小数
                        
                    f.write(f"        {key} = {value},\n")
            f.write("    },\n")
        f.write("}\n")

    # 在文件的最后一行添加表单名
    with open(output_path, "a") as f:
        f.write(f"return {selected_sheet_name}\n")

    print(f"导出完成：{selected_sheet_name} -> {output_path}")


if __name__ == "__main__":
    main()
