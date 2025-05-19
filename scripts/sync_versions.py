#!/usr/bin/env python3
import os
import re
import sys
from pathlib import Path

def read_version(file_path):
    """Project.tomlからバージョンを読み取る"""
    with open(file_path, 'r') as f:
        content = f.read()
        # バージョン行を探す
        version_match = re.search(r'version\s*=\s*"([^"]+)"', content)
        if version_match:
            return version_match.group(1)
        return None

def update_version(file_path, new_version):
    """Project.tomlのバージョンを更新する"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # バージョン行を更新
    updated_content = re.sub(
        r'(version\s*=\s*")[^"]+(")',
        rf'\g<1>{new_version}\g<2>',
        content
    )
    
    with open(file_path, 'w') as f:
        f.write(updated_content)

def update_compat_version(file_path, new_version):
    """[compat]セクションのバージョンを更新する"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # [compat]セクションのバージョンを更新
    updated_content = re.sub(
        r'(CodingTheoryUtils\s*=\s*")[^"]+(")',
        rf'\g<1>{new_version}\g<2>',
        content
    )
    
    with open(file_path, 'w') as f:
        f.write(updated_content)

def main():
    # プロジェクトのルートディレクトリを取得
    root_dir = Path(__file__).parent.parent
    root_project = root_dir / "Project.toml"
    docs_project = root_dir / "docs" / "Project.toml"
    
    # ファイルの存在確認
    if not root_project.exists():
        print(f"Error: {root_project} not found")
        sys.exit(1)
    if not docs_project.exists():
        print(f"Error: {docs_project} not found")
        sys.exit(1)
    
    # 現在のバージョンを取得
    root_version = read_version(root_project)
    docs_version = read_version(docs_project)
    
    if not root_version:
        print("Error: Could not find version in root Project.toml")
        sys.exit(1)
    
    # バージョンが異なる場合は更新
    if root_version != docs_version:
        print(f"Updating versions to {root_version}")
        update_version(docs_project, root_version)
        update_compat_version(docs_project, root_version)
        print("Versions synchronized successfully")
    else:
        print(f"Versions are already synchronized at {root_version}")

if __name__ == "__main__":
    main()