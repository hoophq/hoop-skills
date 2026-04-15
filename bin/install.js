#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const os = require("os");

const USAGE = `
Usage: npx @hoophq/hoop-skills [options]

Install Hoop Gateway API skills for AI coding agents.

Options:
  --global          Install to ~/.cursor/skills/ (personal, all projects)
  --target <path>   Install to a custom directory
  --list            List available skills without installing
  --help            Show this help message

Default: installs to .cursor/skills/ in the current working directory.

Examples:
  npx @hoophq/hoop-skills                    # project-level install
  npx @hoophq/hoop-skills --global           # personal install
  npx @hoophq/hoop-skills --target ./my-dir  # custom path
`.trim();

function main() {
  const args = process.argv.slice(2);

  if (args.includes("--help") || args.includes("-h")) {
    console.log(USAGE);
    process.exit(0);
  }

  const sourceDir = path.join(__dirname, "..", "skills");

  if (args.includes("--list")) {
    const skills = fs
      .readdirSync(sourceDir, { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => d.name);
    console.log("Available skills:\n");
    skills.forEach((s) => console.log(`  ${s}/`));
    console.log(`\n${skills.length} skills total.`);
    process.exit(0);
  }

  const isGlobal = args.includes("--global");
  const targetIdx = args.indexOf("--target");
  const customTarget = targetIdx !== -1 ? args[targetIdx + 1] : null;

  if (targetIdx !== -1 && !customTarget) {
    console.error("Error: --target requires a path argument.");
    process.exit(1);
  }

  let targetDir;
  if (customTarget) {
    targetDir = path.resolve(customTarget);
  } else if (isGlobal) {
    targetDir = path.join(os.homedir(), ".cursor", "skills");
  } else {
    targetDir = path.join(process.cwd(), ".cursor", "skills");
  }

  if (!fs.existsSync(sourceDir)) {
    console.error("Error: skills source directory not found.");
    process.exit(1);
  }

  fs.mkdirSync(targetDir, { recursive: true });

  const skills = fs
    .readdirSync(sourceDir, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name);

  let installed = 0;
  for (const skill of skills) {
    const src = path.join(sourceDir, skill);
    const dest = path.join(targetDir, skill);
    fs.cpSync(src, dest, { recursive: true });
    installed++;
    console.log(`  + ${skill}/`);
  }

  console.log(`\nInstalled ${installed} skills to ${targetDir}`);
}

main();
