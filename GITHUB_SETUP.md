# GitHub Setup Instructions

Your skill is ready to push to GitHub! Follow these steps:

## Option 1: Using GitHub CLI (Recommended)

If you have `gh` CLI installed:

```bash
cd ~/.claude/skills/claude-codex-collaboration

# Authenticate with GitHub (if not already)
gh auth login

# Create repository and push
gh repo create claude-codex-collaboration --public --source=. --remote=origin --push

# Or for private repository:
gh repo create claude-codex-collaboration --private --source=. --remote=origin --push
```

## Option 2: Manual Setup (Current Recommendation)

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `claude-codex-collaboration`
3. Description: "Orchestrate Claude-Codex collaboration using Byterover MCP as shared memory"
4. Choose Public or Private
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

### Step 2: Push Your Code

GitHub will show you commands. Use these:

```bash
cd ~/.claude/skills/claude-codex-collaboration

# Add GitHub as remote
git remote add origin https://github.com/YOUR_USERNAME/claude-codex-collaboration.git

# Or with SSH (if you have SSH keys set up):
git remote add origin git@github.com:YOUR_USERNAME/claude-codex-collaboration.git

# Push to GitHub
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### Step 3: Verify

Visit your repository: `https://github.com/YOUR_USERNAME/claude-codex-collaboration`

You should see:
- ✅ README.md displayed on homepage
- ✅ All 8 files committed
- ✅ 2,142+ lines of code
- ✅ MIT License badge

## Repository Details

**What's being pushed:**

```
claude-codex-collaboration/
├── .gitignore                    # Git ignore rules
├── LICENSE                       # MIT License
├── README.md                     # Main documentation
├── QUICKSTART.md                 # 5-minute quick start
├── SKILL.md                      # Complete workflow guide
├── collaborate.sh                # Automated helper script
└── references/
    ├── example-session.md        # Full example walkthrough
    └── byterover-integration.md  # Byterover MCP integration
```

**Stats:**
- 8 files
- 2,142 lines of code
- 3 markdown docs
- 1 executable script
- 2 reference guides

## Post-Push Setup (Optional)

### Add Topics/Tags

Add these topics to help others discover your skill:
- `claude-code`
- `codex`
- `ai-agents`
- `byterover`
- `mcp`
- `collaboration`
- `agent-skill`
- `claude-skill`

### Create a GitHub Release

After pushing:

```bash
cd ~/.claude/skills/claude-codex-collaboration

# Create a tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial production-ready version"

# Push tag
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

### Add Badge to README

Consider adding a badge:

```markdown
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

## Sharing Your Skill

Once pushed, share with:

### Claude Code Community
Share in Claude Code discussions, Discord, or forums

### Installation Instructions for Others

Others can install your skill with:

```bash
# Clone to Claude skills directory
git clone https://github.com/YOUR_USERNAME/claude-codex-collaboration.git ~/.claude/skills/claude-codex-collaboration

# Or if already in skills directory:
cd ~/.claude/skills
git clone https://github.com/YOUR_USERNAME/claude-codex-collaboration.git
```

### Make it Discoverable

Add to your GitHub profile README or create a skills directory.

## Troubleshooting

### Permission Denied (SSH)

If you see "Permission denied (publickey)":
- Use HTTPS URL instead: `https://github.com/...`
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Already Exists

If repository already exists:
```bash
git remote set-url origin https://github.com/YOUR_USERNAME/claude-codex-collaboration.git
git push -u origin main
```

### Push Rejected

If push is rejected:
```bash
git pull origin main --rebase
git push -u origin main
```

---

**Ready to push?** Follow Option 2 above and paste your GitHub username when ready!
