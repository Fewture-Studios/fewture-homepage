# Cursor Agent Rules

## Workspace Context
This file contains the rules for the Cursor AI agent when working in the `/Users/r/Desktop/00_code/` workspace.

## Global Rules Location
The complete set of rules and guidelines can be found at:
`/Users/r/Desktop/00_code/x_rules/.cursorrules.md`

## Key Directives
1. Always check and follow the global rules in the workspace
2. Maintain global state across sessions
3. Update global environment variables appropriately
4. Follow the workspace structure guidelines
5. Document changes in the global journal

## Session Management
When the user indicates session end:
- Update global state in x_memory/
- Create/update journal entries in x_journal/
- Sync environment variables in x_variables/
- Maintain persistent memory
- Update global configurations
- Document new patterns

## Environment Handling
- Use the master global .env from x_variables/
- Follow the hierarchical environment variable structure
- Maintain security for sensitive information
- Keep documentation updated

## Reference
For complete rules and guidelines, refer to:
`/Users/r/Desktop/00_code/x_rules/.cursorrules.md` 