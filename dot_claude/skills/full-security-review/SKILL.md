---
name: full-security-review
description: Full codebase security review — secrets, injection, auth issues, dependency risks (not just pending changes)
---

Perform a security review of the Berkshire codebase. Focus on issues that matter for a data collection pipeline with API keys, database access, and web scraping.

## Checks

### 1. Secrets & Credentials
- Scan for hardcoded API keys, passwords, tokens, or connection strings in source files
- Verify .env files are in .gitignore
- Check that .env.example contains no real values
- Look for secrets in git history if available

### 2. Injection Risks
- SQL injection: verify all database queries use parameterized queries (SQLAlchemy ORM/Core, not raw strings)
- Command injection: check for unsanitized input passed to shell commands or subprocess calls
- XSS: check frontend for dangerouslySetInnerHTML or unescaped user input rendering

### 3. API & Network
- Check that API keys are loaded from environment, not hardcoded
- Review HTTP client usage (httpx) for SSRF risks
- Check CORS configuration in FastAPI
- Review proxy configuration for credential leaks

### 4. Dependencies
- Check for known vulnerable packages (review versions in pyproject.toml and package.json)
- Flag any pinned versions that are significantly outdated

### 5. Authentication & Authorization
- Review FastAPI endpoint protection (if API endpoints exist)
- Check database connection security (SSL, connection pooling)

## Output

Provide a summary table with:
- Severity (Critical / High / Medium / Low)
- Finding description
- File and line number
- Recommended fix

Address Critical and High findings first with concrete fix suggestions.
