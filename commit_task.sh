#!/bin/bash

# Check if the required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <TaskID> <Path to Repository>"
  exit 1
fi

# Parameters
TASK_ID="$1"
REPO_PATH="$2"
CSV_FILE="sprint.csv" # Path to the CSV file

# Check if the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Error: $CSV_FILE not found!"
  exit 1
fi

# Extract task details from the CSV file
TASK_DETAILS=$(awk -v id="$TASK_ID" -F, '$1 == id {print $0}' "$CSV_FILE")
if [ -z "$TASK_DETAILS" ]; then
  echo "Error: TaskID $TASK_ID not found in $CSV_FILE"
  exit 1
fi

# Parse the task details
IFS=',' read -r TASKID DESC BRANCH DEVELOPER GITHUB_URL <<< "$TASK_DETAILS"

# Output task details for confirmation
echo "TaskID: $TASKID"
echo "Description: $DESC"
echo "Branch: $BRANCH"
echo "Developer: $DEVELOPER"
echo "GitHub URL: $GITHUB_URL"

# Navigate to the Git repository
cd "$REPO_PATH" || exit 1

# Ensure the repository is up-to-date
git fetch

# Switch to the specified branch (create it if it doesn't exist)
git checkout "$BRANCH" || git checkout -b "$BRANCH"

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Validate that the current branch is the same as the user-provided branch
if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
  echo "Error: The current branch ($CURRENT_BRANCH) does not match the specified branch ($BRANCH)."
  exit 1
fi

# Create or modify a file based on the task description
FILE_NAME="task_${TASKID}.txt"
echo "$DESC" > "$FILE_NAME"

# Stage the file
git add "$FILE_NAME"

# Generate the current time
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Format the commit message
COMMIT_MESSAGE="$TASKID-$CURRENT_TIME-$BRANCH-$DEVELOPER-$DESC"

# Commit the changes
git commit -m "$COMMIT_MESSAGE"

# Push the changes
git push origin "$BRANCH"

echo "Task $TASK_ID has been committed and pushed to branch '$BRANCH'."
echo "Commit message: $COMMIT_MESSAGE"
