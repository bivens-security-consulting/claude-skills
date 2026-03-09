---
name: fetch-github-skills
description: Fetches and installs ai skills from a specified GitHub repository. Use when the user wants to download new skills or update existing ones.
---

# Fetch GitHub Skills for AI

This skill allows AI to retrieve remote skill definitions and install them into the local environment.

## Workflow

1.  **Identify Repository**: Determine the GitHub URL for the skills repository.
2.  **Clone/Pull**: Use `git` to clone the repository to the current working directory.
3.  **Validate**: Scan the repository for folders containing a `SKILL.md` file.
4.  **Install**: Copy the valid skill folders into `~/.ai/skills/`.
5.  **Clean Up**: Remove the temporary clone.

## Instructions for AI

* When a user provides a GitHub URL, use the terminal to run `git clone <url> <current_working_dir>/temp_dir>`.
* Iterate through the directories in the cloned repo. If a directory contains a `SKILL.md` file, treat it as a valid skill.
* Ask for confirmation before overwriting any existing skills in `~/.ai/skills/`.
* Once confirmed, use `cp -r <skill_folder> ~/.ai/skills/`.
* Remind the user to run `/skills reload` for the new skills to take effect.

## Safety Guidelines

* **Audit First**: List the skills found and their descriptions before installing.
* **No Execution**: Do not run scripts from the repo without being asked.