{
  flake.nixosModules.ai = { pkgs, ... }: {
    sops = {
      secrets = {
        librechat = {
          owner = "librechat";
        };
      };
    };

    services = {
      librechat = {
        enable = true;
        enableLocalDB = true;
        credentialsFile = "/run/secrets/librechat";

        env = {
          HOST = "localhost";
          PORT = "3080";
          ALLOW_EMAIL_LOGIN = false;
          ALLOW_REGISTRATION = false;
          ALLOW_SOCIAL_LOGIN = true;
          ALLOW_SOCIAL_REGISTRATION = true;
          DEEPSEEK_API_KEY = "user_provided";
          OPENROUTER_API_KEY = "user_provided";
          DOMAIN_CLIENT = "https://chat.asherif.xyz";
          DOMAIN_SERVER = "https://chat.asherif.xyz";
          ENDPOINTS = "agents,gptPlugins,google,deepseek,custom";    
          GOOGLE_KEY = "user_provided";    
          GOOGLE_MODELS = "gemini-3-pro-preview,gemini-3-pro-image-preview,gemini-3-flash-preview";    
          OPENID_ADMIN_ROLE = "admin";    
          OPENID_ADMIN_ROLE_TOKEN_KIND = "access";    
          OPENID_AUTO_REDIRECT = true;    
          OPENID_CALLBACK_URL = "/oauth/openid/callback";    
          OPENID_GENERATE_NONCE = true;    
          OPENID_JWKS_URL_CACHE_ENABLED = true;    
          OPENID_REUSE_TOKENS = true;
          OPENID_SCOPE = "openid profile email offline_access";
          OPENID_USE_END_SESSION_ENDPOINT = true;
          SEARXNG_INSTANCE_URL = "https://search.asherif.xyz";
        };

        settings = {
          version = "1.0.8";

          webSearch = {
            searchProvider = "searxng";
          };

          #speech = {
          #  tts = {
          #    localai = {
          #      url = "http://localhost:5300/v1/audio/synthesize";
          #      backend = "coqui";

          #      voices = [
          #        "tts_models/en/ljspeech/tacotron2-DDC"
          #      ];
          #    };
          #  };
          #};

          memory = {
            disabled = false;
            personalize = true;
            tokenLimit = 32000;
            messageWindowSize = 5;

            agent = {
              provider = "Google";
              model = "gemini-3-flash-preview";
            };
          };

          mcpServers = {
            nixos = {
              command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
              args = [
                "-t"
                "stdio"
              ];
            };

            gitea = {
              command = "${pkgs.gitea-mcp-server}/bin/gitea-mcp";

              args = [
                "-t"
                "stdio"
                "--host"
                "https://git.asherif.xyz"
                "--token"
                "caf6a3dacae1e3ce2688471d9e4f7d7b6cd6a820"
              ];
            };
          };

          endpoints = {
            agents = {
              capabilities = [ "context" "ocr" ];
            };

            custom = [
              {
                name = "OpenRouter";
                apiKey = "\${OPENROUTER_API_KEY}";
                baseURL = "https://openrouter.ai/api/v1";
                titleConvo = true;
                titleModel = "moonshotai/kimi-k2.5";
                modelDisplayLabel = "OpenRouter";

                models = {
                  default = [
                    "moonshotai/kimi-k2.5"
                    "deepseek/deepseek-v3.2"
                    "z-ai/glm-5"
                  ];
                  fetch = true;
                };
              }
              {
                name = "Deepseek";
                apiKey = "\${DEEPSEEK_API_KEY}";
                baseURL = "https://api.deepseek.com/v1";
                titleConvo = true;
                titleModel = "deepseek-chat";
                modelDisplayLabel = "Deepseek";

                models = {
                  fetch = true;

                  default = [
                    "deepseek-chat"
                    "deepseek-reasoner"
                  ];
                };
              }
            ];
          };
        };
      };

      mongodb = {
        enable = true;
        package = pkgs.mongodb-ce;
      };
      
      nginx = {
        virtualHosts = {
          "chat.asherif.xyz" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = null;
            locations."/" = {
              proxyPass = "http://localhost:3080";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };

      #tts = {
      #  servers = {
      #    english = {
      #      enable = true;
      #      port = 5300;
      #      model = "tts_models/en/ljspeech/tacotron2-DDC";
      #    };
      #  };
      #};
    };
  };
}
