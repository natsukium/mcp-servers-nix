## configFile

Generated config file derived from the settings\.



*Type:*
absolute path *(read only)*

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/config\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/config.nix)



## fileName



Configuration file name\.



*Type:*
string



*Default:*

```nix
"claude_desktop_config.json"
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/config\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/config.nix)



## flavor



Configuration file type\.

 - “claude”: Standard Claude Desktop configuration format using “mcpServers” key
 - “claude-code”: Claude Code configuration format using “mcpServers” key
 - “codex”: Codex CLI configuration format using “mcp_servers” key
 - “opencode”: OpenCode configuration format using “mcp” key with command as array
 - “vscode”: VSCode global configuration format using “mcp\.servers” keys
 - “vscode-workspace”: VSCode workspace configuration format with top-level “servers” key,
 - “zed”: Zed configuration format with top-level “context_servers” key,



*Type:*
one of “claude”, “claude-code”, “codex”, “opencode”, “vscode”, “vscode-workspace”, “zed”



*Default:*

```nix
"claude"
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/config\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/config.nix)



## format



Configuration file format\.



*Type:*
one of “json”, “yaml”, “toml”, “toml-inline”



*Default:*

```nix
"json"
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/config\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/config.nix)



## programs\.clickup\.enable



Whether to enable clickup\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.package



The clickup-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.clickup-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.clickup\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/clickup\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/clickup.nix)



## programs\.codex\.enable



Whether to enable codex\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.package



The codex package to use\.



*Type:*
package



*Default:*

```nix
pkgs.codex
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.codex\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/codex\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/codex.nix)



## programs\.context7\.enable



Whether to enable context7\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.package



The context7-mcp package to use\.



*Type:*
package



*Default:*

```nix
pkgs.context7-mcp
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.context7\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/context7\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/context7.nix)



## programs\.deepl\.enable



Whether to enable deepl\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.package



The deepl-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.deepl-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.deepl\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/deepl\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/deepl.nix)



## programs\.esa\.enable



Whether to enable esa\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.package



The esa-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.esa-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.esa\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/esa\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/esa.nix)



## programs\.everything\.enable



Whether to enable everything\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.package



The mcp-server-everything package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-everything
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.everything\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/everything\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/everything.nix)



## programs\.fetch\.enable



Whether to enable fetch\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.package



The mcp-server-fetch package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-fetch
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.fetch\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/fetch\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/fetch.nix)



## programs\.filesystem\.enable



Whether to enable filesystem\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.package



The mcp-server-filesystem package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-filesystem
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.filesystem\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/filesystem\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/filesystem.nix)



## programs\.freee\.enable



Whether to enable freee\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.package



The freee-mcp package to use\.



*Type:*
package



*Default:*

```nix
pkgs.freee-mcp
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.freee\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/freee\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/freee.nix)



## programs\.git\.enable



Whether to enable git\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.package



The mcp-server-git package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-git
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.git\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/git\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/git.nix)



## programs\.github\.enable



Whether to enable github\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.package



The github-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.github-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.passwordCommand

Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.github\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/github\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/github.nix)



## programs\.grafana\.enable



Whether to enable grafana\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.package



The mcp-grafana package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-grafana
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.grafana\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/grafana\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/grafana.nix)



## programs\.mastra\.enable



Whether to enable mastra\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.package



The mastra-mcp-docs-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mastra-mcp-docs-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.mastra\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/mastra\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/mastra.nix)



## programs\.memory\.enable



Whether to enable memory\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.package



The mcp-server-memory package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-memory
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.memory\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/memory\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/memory.nix)



## programs\.netdata\.enable



Whether to enable netdata\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.package



The nd-mcp package to use\.



*Type:*
package



*Default:*

```nix
pkgs.nd-mcp
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.netdata\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/netdata\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/netdata.nix)



## programs\.nixos\.enable



Whether to enable nixos\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.package



The mcp-nixos package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-nixos
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.nixos\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/nixos\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/nixos.nix)



## programs\.notion\.enable



Whether to enable notion\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.package



The notion-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.notion-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.notion\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/notion\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/notion.nix)



## programs\.playwright\.enable



Whether to enable playwright\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.package



The playwright-mcp package to use\.



*Type:*
package



*Default:*

```nix
pkgs.playwright-mcp
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.executable



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
if pkgs.stdenv.hostPlatform.isDarwin then
  lib.getExe pkgs.google-chrome
else
  lib.getExe pkgs.chromium

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.playwright\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/playwright\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/playwright.nix)



## programs\.sequential-thinking\.enable



Whether to enable sequential-thinking\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.package



The mcp-server-sequential-thinking package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-sequential-thinking
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.sequential-thinking\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/sequential-thinking\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/sequential-thinking.nix)



## programs\.serena\.enable



Whether to enable serena\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.enableWebDashboard



Enable or disable the Serena web dashboard\.
If null, the default setting will be used\.



*Type:*
null or boolean



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.package



The serena package to use\.



*Type:*
package



*Default:*

```nix
pkgs.serena
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.context



Built-in context name\. See https://github\.com/oraios/serena/tree/main/src/serena/resources/config/contexts for available contexts\.
If null, the default context will be used\.



*Type:*
null or one of “agent”, “chatgpt”, “claude-code”, “codex”, “desktop-app”, “ide-assistant”, “oaicompat-agent”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.extraPackages



Extra packages available in the serena wrapper’s PATH\.
This is useful for including language servers and other tools
that serena needs to access\.



*Type:*
list of package



*Default:*

```nix
[ ]
```



*Example:*

```nix
[ pkgs.nixd pkgs.rust-analyzer ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.serena\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/serena\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/serena.nix)



## programs\.slite\.enable



Whether to enable slite\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.package



The slite-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.slite-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.slite\.useRemote



Use Slite’s remote MCP server via streamable HTTP instead of the local stdio package\.
When enabled, type defaults to “http” and url defaults to “https://api\.slite\.com/mcp”\.
Authentication is handled via OAuth by the MCP client\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/slite\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/slite.nix)



## programs\.tavily\.enable



Whether to enable tavily\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.package



The tavily-mcp package to use\.



*Type:*
package



*Default:*

```nix
pkgs.tavily-mcp
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.env

Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.tavily\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/tavily\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/tavily.nix)



## programs\.terraform\.enable



Whether to enable terraform\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.package



The terraform-mcp-server package to use\.



*Type:*
package



*Default:*

```nix
pkgs.terraform-mcp-server
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.terraform\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/terraform\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/terraform.nix)



## programs\.textlint\.enable



Whether to enable textlint\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.package



The textlint package to use\.



*Type:*
package



*Default:*

```nix
pkgs.textlint
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.configFile



Path to \.textlintrc configuration file\.
This file specifies which rules to enable and their settings\.
Takes precedence over the settings option\.



*Type:*
null or absolute path



*Default:*

```nix
null
```



*Example:*

```nix
./.textlintrc.json
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.extensions



List of textlint extension packages (rules, plugins, presets, filter-rules, configs)\.
These packages will be available via NODE_PATH\.



*Type:*
list of package



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  pkgs.textlint-rule-alex
  pkgs.textlint-plugin-org
  pkgs.textlint-rule-preset-ja-technical-writing
]

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.settings



Textlint configuration expressed as Nix attributes\.
Will be converted to JSON and used as the configuration file\.
Ignored if configFile is set\.



*Type:*
attribute set of anything



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  rules = {
    alex = true;
    terminology = {
      defaultTerms = true;
    };
  };
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.textlint\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/textlint\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/textlint.nix)



## programs\.time\.enable



Whether to enable time\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.package



The mcp-server-time package to use\.



*Type:*
package



*Default:*

```nix
pkgs.mcp-server-time
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.args



Array of arguments passed to the command\.



*Type:*
list of (boolean or signed integer or string)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.env



Environment variables for the server\.
For security reasons, do not hardcode your credentials in the env\.
All files in /nix/store can be read by anyone with access to the store\.
Always use envFile instead\.



*Type:*
attribute set of (boolean or signed integer or string)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.envFile



Path to an \.env from which to load additional environment variables\.
When flavor is set to ‘vscode’, the environment file is passed directly as a parameter instead of wrapping by default\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.headers



HTTP headers for authentication\.
Used with “http” and “sse” transport types\.
For security reasons, do not hardcode credentials in headers\.
Use variable expansion syntax (e\.g\., ${VAR}) supported by the client\.
Set environment variables before launching the client instead\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{ Authorization = "Bearer \${API_TOKEN}"; }

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.passwordCommand



Command to execute to retrieve secrets\. Can be specified in two ways:

 1. As a string: The command should output in the format “KEY=VALUE” which will be exported as environment variables\.
    Example: “pass mcp-server”

 2. As an attribute set: Keys are environment variable names and values are command lists that output the value\.
    Example: { GITHUB_PERSONAL_ACCESS_TOKEN = \[ “gh” “auth” “token” ]; }

This is useful for integrating with password managers or similar tools\.
passwordCommand is always handled via the wrapper regardless of flavor\.



*Type:*
null or string or attribute set of list of string



*Default:*

```nix
null
```



*Example:*

```nix
{
  GITHUB_PERSONAL_ACCESS_TOKEN = [
    "gh"
    "auth"
    "token"
  ];
}

```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.type



Server connection type\.



*Type:*
null or one of “http”, “sse”, “stdio”



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## programs\.time\.url



URL of the server (for “http” and “sse”)\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/time\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/time.nix)



## settings



This option has no description\.



*Type:*
open submodule of (JSON value)



*Default:*

```nix
{ }
```

*Declared by:*
 - [\<mcp-servers-nix/modules/servers/config\.nix>](https://github.com/natsukium/mcp-servers-nix/blob/main/modules/servers/config.nix)


