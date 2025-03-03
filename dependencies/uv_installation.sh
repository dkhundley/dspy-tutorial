echo 'Installing uv...'
curl -LsSf https://astral.sh/uv/install.sh | sh

echo 'Installing Python 3.12 with uv...'
uv python install 3.12

echo 'Initializing uv project...'
echo "3.12" > .python-version

echo 'Creating a uv venv virtual environment with Python 3.12...'
uv venv --python=3.12 .venv

echo 'Activating the venv virtual environment...'
source .venv/bin/activate

echo 'Installing Python dependencies with uv...'
# Checking to see if dependencies are empty or don't exist
if grep -q "dependencies = \[\]" pyproject.toml 2>/dev/null || ! grep -q "dependencies =" pyproject.toml 2>/dev/null; then
    
    # Installing each Python dependency from the requirements.txt file with uv
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            uv add "$line"
        fi
    done < "dependencies/requirements.txt"
else

    # Syncing any dependencies that are already in the pyproject.toml file
    uv sync
fi

echo 'Creating a Jupyter notebook kernel using the uv venv...'
python -m ipykernel install --user --name 'dkhundley_venv' --display-name 'dkhundley_venv'

echo 'uv installation complete!'
