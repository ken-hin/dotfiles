# Skills audit, 2026-11-13

Data: 7 Claude transcripts plus `~/.claude/history.jsonl`. Over that history Claude invoked 0 skills and used 0 subagents. The only ECC entries you ran yourself were `/ecc-guide` (4×) and `/resume-session` (2×).

Stack detected in `~/dev`: Python (Django, FastAPI, pandas, scikit-learn, pytest), SvelteKit + Tailwind, React/TS + Vite, Java Spring Boot + JPA, Postgres, Docker.

## What loads every session

| Source | Count | Cost |
| --- | --- | --- |
| ECC skill + command names (always listed) | 412 | ~2.5k tokens |
| ECC skill descriptions | 314 | ~24k tokens raw; capped by the listing budget (1% of context) and dropped least-used first |
| ECC agent descriptions (Agent tool) | 71 | ~4.2k tokens |
| ECC SessionStart hook context | 1 | up to 8,000 chars (~2k tokens) |
| claude.ai synced skills (`anthropic-skills:*`) | 13 | small |
| Your `~/.claude/skills/` copies | 21 | 0: already `off` |

**`skillOverrides` doesn't apply to plugin skills** (per the Claude Code docs). Your 21 `off` entries hide only the user-level copies; all 314 ECC skills stay listed.

## ECC skills by group

### RELEVANT to your stack (39, ~2735 description tokens)

`api-design`, `backend-patterns`, `codebase-onboarding`, `coding-standards`, `database-migrations`, `deployment-patterns`, `django-celery`, `django-patterns`, `django-security`, `django-tdd`, `django-verification`, `docker-patterns`, `documentation-lookup`, `e2e-testing`, `error-handling`, `fastapi-patterns`, `frontend-patterns`, `git-workflow`, `github-ops`, `java-coding-standards`, `jpa-patterns`, `postgres-patterns`, `prisma-patterns`, `python-patterns`, `python-testing`, `pytorch-patterns`, `react-patterns`, `react-performance`, `react-testing`, `search-first`, `security-review`, `springboot-patterns`, `springboot-security`, `springboot-tdd`, `springboot-verification`, `tdd-workflow`, `typescript-patterns`, `verification-loop`, `vite-patterns`

### Agent / harness meta (ECC internals, loops, evals) (124, ~10083 description tokens)

`accessibility`, `agent-architecture-audit`, `agent-eval`, `agent-harness-construction`, `agent-introspection-debugging`, `agent-runtime-gateway-smoke-test`, `agent-security-hardening`, `agent-self-evaluation`, `agent-sort`, `agentic-engineering`, `agentic-os`, `ai-first-engineering`, `ai-regression-testing`, `api-connector-builder`, `architecture-decision-records`, `automation-audit-ops`, `autonomous-agent-harness`, `autonomous-loops`, `benchmark`, `benchmark-methodology`, `benchmark-optimization-loop`, `blender-motion-state-inspection`, `blueprint`, `brownfield-retrospective`, `browser-qa`, `canary-watch`, `change-impact`, `ck`, `claude-devfleet`, `click-path-audit`, `code-tour`, `codehealth-mcp`, `config-gc`, `configure-ecc`, `content-hash-cache-pattern`, `context-and-decisions`, `context-budget`, `continuous-agent-loop`, `continuous-learning`, `continuous-learning-v2`, `contract-first`, `conventional-commit-review`, `cost-aware-llm-pipeline`, `cost-tracking`, `council`, `council-multi-model`, `dashboard-builder`, `data-throughput-accelerator`, `deepseek-harness-setup`, `delivery-gate`, `dmux-workflows`, `docs-governance`, `dynamic-workflow-mode`, `ecc-guide`, `ecc-recipes`, `ecc-tools-cost-audit`, `enterprise-agent-ops`, `eval-harness`, `frontend-a11y`, `gan-style-harness`, `gateguard`, `generating-python-installer`, `hermes-imports`, `hexagonal-architecture`, `i18n-sync`, `inherit-legacy-style`, `intent-driven-development`, `iterative-retrieval`, `latency-critical-systems`, `living-docs-governance`, `make-interfaces-feel-better`, `mcp-dependency-review`, `mcp-server-patterns`, `ml-adoption-playbook`, `mle-workflow`, `module-governance`, `module-regression`, `motion-advanced`, `motion-foundations`, `motion-patterns`, `nanoclaw-repl`, `nasiko-control-plane`, `nutrient-document-processing`, `openclaw-persona-forge`, `opensource-pipeline`, `operator-approval-loop`, `orch-add-feature`, `orch-build-mvp`, `orch-change-feature`, `orch-fix-defect`, `orch-pipeline`, `orch-refine-code`, `parallel-execution-optimizer`, `plan-orchestrate`, `plankton-code-quality`, `product-capability`, `product-lens`, `prompt-caching-strategy`, `prompt-optimizer`, `recursive-decision-ledger`, `repo-scan`, `rules-distill`, `safety-guard`, `santa-method`, `security-bounty-hunter`, `security-scan`, `skill-comply`, `skill-host-compat`, `skill-scout`, `skill-stocktake`, `strategic-compact`, `taste`, `taste-application`, `taste-distillation`, `team-agent-orchestration`, `team-builder`, `terminal-opener`, `terminal-ops`, `test-collaboration`, `token-budget-advisor`, `token-card`, `ui-demo`, `unified-memory`, `workspace-surface-audit`

### Other languages (not in your projects) (49, ~3179 description tokens)

`android-clean-architecture`, `angular-developer`, `bun-runtime`, `compose-multiplatform-patterns`, `cpp-coding-standards`, `cpp-testing`, `csharp-testing`, `dart-flutter-patterns`, `dotnet-patterns`, `flutter-dart-code-review`, `foundation-models-on-device`, `fsharp-testing`, `golang-patterns`, `golang-testing`, `ios-icon-gen`, `kotlin-coroutines-flows`, `kotlin-exposed-patterns`, `kotlin-ktor-patterns`, `kotlin-patterns`, `kotlin-testing`, `laravel-patterns`, `laravel-plugin-discovery`, `laravel-security`, `laravel-tdd`, `laravel-verification`, `liquid-glass-design`, `mybatis-patterns`, `nestjs-patterns`, `nextjs-turbopack`, `nuxt4-patterns`, `perl-patterns`, `perl-security`, `perl-testing`, `quarkus-patterns`, `quarkus-security`, `quarkus-tdd`, `quarkus-verification`, `rails-patterns`, `react-native-patterns`, `rust-patterns`, `rust-testing`, `swift-actor-persistence`, `swift-concurrency-6-2`, `swift-protocol-di-testing`, `swiftui-patterns`, `tinystruct-patterns`, `ui-to-vue`, `vue-patterns`, `windows-desktop-e2e`

### Healthcare / finance / logistics / business ops (35, ~3091 description tokens)

`agent-payment-x402`, `carrier-relationship-management`, `competitive-platform-analysis`, `competitive-report-structure`, `customer-billing-ops`, `customs-trade-compliance`, `defi-amm-security`, `design-system`, `energy-procurement`, `esign-field-placement`, `evm-token-decimals`, `finance-billing-ops`, `frontend-design-direction`, `healthcare-cdss-patterns`, `healthcare-emr-patterns`, `healthcare-eval-harness`, `healthcare-phi-compliance`, `hipaa-compliance`, `inventory-demand-planning`, `investor-materials`, `investor-outreach`, `lead-intelligence`, `llm-trading-agent-security`, `logistics-exception-management`, `loop-design-check`, `market-research`, `master-agreement-generator`, `nodejs-keccak256`, `prediction-market-oracle-research`, `prediction-market-risk-review`, `production-scheduling`, `quality-nonconformance`, `ralphinho-rfc-pipeline`, `returns-reverse-logistics`, `visa-doc-translate`

### Marketing / content / social / media (19, ~1457 description tokens)

`article-writing`, `brand-discovery`, `brand-voice`, `connections-optimizer`, `content-engine`, `crosspost`, `fal-ai-media`, `frontend-slides`, `growth-log`, `manim-video`, `marketing-campaign`, `remotion-video-creation`, `seo`, `social-graph-ranker`, `social-publisher`, `tasteforge-video`, `video-editing`, `videodb`, `x-api`

### Science / research / niche data (17, ~1393 description tokens)

`bengali-nlp`, `data-scraper-agent`, `deep-research`, `exa-search`, `ito-baskets`, `ito-compute`, `ito-inference`, `ito-training`, `osint-investigation`, `recsys-pipeline-architect`, `regex-vs-llm-structured-text`, `research-ops`, `scientific-db-pubmed-database`, `scientific-db-uspto-database`, `scientific-pkg-gget`, `scientific-thinking-literature-review`, `scientific-thinking-scholar-evaluation`

### Networking / homelab / infra (16, ~1173 description tokens)

`cisco-ios-patterns`, `clickhouse-io`, `flox-environments`, `homelab-network-readiness`, `homelab-network-setup`, `homelab-pihole-dns`, `homelab-vlan-segmentation`, `homelab-wireguard-vpn`, `kubernetes-patterns`, `mysql-patterns`, `netmiko-ssh-automation`, `network-bgp-diagnostics`, `network-config-validation`, `network-interface-health`, `redis-patterns`, `uncloud`

### Comms / personal ops (10, ~664 description tokens)

`counterparty-channel-discipline`, `email-ops`, `google-workspace-ops`, `jira-integration`, `knowledge-ops`, `mailtrap-email-integration`, `messages-ops`, `project-flow-ops`, `story-lifecycle`, `unified-notifications-ops`

### Unsorted (5, ~407 description tokens)

`dev-team`, `hookify-rules`, `issue-review`, `plan-canvas`, `production-audit`

