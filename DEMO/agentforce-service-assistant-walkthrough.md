# Meridian Service Assistant — Agentforce Demo Script

**Goal:** show a real, working Agentforce agent grounded in real Salesforce
data — not a slide about what Agentforce could theoretically do. 5 minutes,
five parts: Introduction, Problem, Real Conversation, Escalation, Business
Benefit.

**What this agent is:** "Meridian Service Assistant" — a customer-facing
Agentforce agent that answers Service Order status questions, explains
exactly what's blocking fulfillment and why, lists pending Provisioning
Tasks, and escalates to the Provisioning team by creating a tracked Case and
Escalation Log when a human needs to step in. Built with Agent Script
(`aiAuthoringBundles/Meridian_Service_Assistant`), backed by 3 Autolaunched
Flows that do the real Salesforce work.

## Before this demo

Have the org open, logged in, on the Agentforce Builder / conversation view
for Meridian Service Assistant, with Service Order **SO-00001** already
seeded (Account "Bright Harbor Logistics", Stage = Provisioning, one
Provisioning Task Blocked, one Not Started, one Complete — see
`../scripts/apex/seed-agent-demo-data.apex` /
`../force-app/main/default/flows/Meridian_Seed_Demo_Data.flow-meta.xml`).

## Timing

| Time      | Section                  | Say / show                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 0:00–0:45 | **1. Introduction**      | "This is Meridian Service Assistant — an Agentforce agent I built on top of the Meridian Communications platform. It's grounded entirely in real Salesforce data: Service Orders and Provisioning Tasks, the same objects and Flows that run the fulfillment side of this org. Nothing here is scripted responses — every answer comes from an actual Flow querying actual records."                                                                                                             |
| 0:45–1:30 | **2. The problem**       | "A B2B connectivity provider's support team spends a lot of its day answering one question in different words: 'where's my order.' That's not a hard question, but it's a slow one to answer by hand — someone has to open the order, check the stage, open related Provisioning Tasks, figure out which one is stuck and why, then decide whether it needs to be escalated. This agent does that whole lookup in one turn, and it's honest when it doesn't know something instead of guessing." |
| 1:30–3:30 | **3. Real conversation** | Type the utterances below live. Full expected exchange in the section below — this is not simulated, every number and status comes from the live org.                                                                                                                                                                                                                                                                                                                                            |
| 3:30–4:15 | **4. Escalation**        | Continue the same conversation: ask the agent to escalate. It creates a real Case (Record Type: Provisioning Request) and a real Escalation Log entry, linked to each other, and confirms it in plain language — no invented case numbers.                                                                                                                                                                                                                                                       |
| 4:15–5:00 | **5. Business benefit**  | "This turns a 5-to-10-minute manual lookup-and-triage into a 10-second conversation, with a full audit trail — the Case and Escalation Log are real records the Provisioning team picks up from their queue, not a note in a chat transcript that goes nowhere. And because it's built on Agent Script and Flows, not hardcoded logic, extending it to Billing or Support is the same pattern, not a rebuild."                                                                                   |

## 3. Real conversation — full script

These exact exchanges are validated end-to-end against the live org and
seeded data (`SO-00001`, one Blocked task, one Not Started task, one
Complete task) — see verification note at the bottom of this file. Say the
customer lines; the agent lines are what the underlying actions actually
return, phrased the way the agent's instructions tell it to phrase them.

> **Customer:** Where is my service order? It's SO-00001.
>
> **Agent:** Service Order SO-00001 is currently in the **Provisioning**
> stage. There's one thing holding it up right now: the Equipment Install
> task (PT-00002) is marked **Blocked** and was due 2026-07-13. Want me to
> escalate this to our Provisioning team?

> **Customer:** Why is it delayed?
>
> **Agent:** It's the Equipment Install step — Provisioning Task PT-00002 is
> currently Blocked, and it was due 2026-07-13, so it's also overdue. That's
> the only thing standing between this order and moving to Active.

> **Customer:** What else is left to do on this order?
>
> **Agent:** Two tasks are still open on SO-00001: **PT-00002 — Equipment
> Install**, status Blocked, due 2026-07-13; and **PT-00003 —
> Configuration**, status Not Started, due 2026-07-18. Site Survey is
> already complete.

## 4. Escalation — full script

> **Customer:** Yes, please escalate it. We need this equipment install
> unblocked — our office reopens in two weeks and we need internet live
> before then.
>
> **Agent:** Done — I've escalated Service Order SO-00001 to the
> Provisioning team. I created a Case and an Escalation Log entry so this is
> tracked and someone will follow up on it.

Behind that one line: a real `Case` (Record Type **Provisioning Request**,
Status **Escalated**, linked to the Bright Harbor Logistics account) and a
real `Escalation_Log__c` record (`Escalated_From__c` = "Meridian Service
Assistant (Agentforce)", `Escalated_To__c` = "Provisioning Team",
`Escalation_Reason__c` = the customer's actual words) — both created by
`Meridian_Escalate_Service_Order`, both visible immediately in the org.

## If they interrupt with a question

- **"Is this actually querying real records, or is the LLM making this up?"**
  → Every number comes from an Autolaunched Flow (`Meridian_Get_Service_Order_Status`,
  `Meridian_List_Pending_Provisioning_Tasks`, `Meridian_Escalate_Service_Order`)
  wired in as the agent's Actions. The agent's instructions explicitly tell
  it to never invent an order number, stage, task, or status — if a Flow
  reports "not found," it says so instead of guessing. Ask it about an order
  number that doesn't exist and watch it say exactly that.
- **"What happens if it can't find the order?"** → Ask it about `SO-99999`
  live — it responds "No service order found with number SO-99999" instead
  of fabricating a status.
- **"Why Flows instead of Apex for the actions?"** → Same reasoning as the
  rest of this project: every one of these three actions had a clean
  declarative solution, so that's what got built. Not a limitation, a
  choice.

## What NOT to do in this demo

Don't read the Agent Script file out loud — show the conversation, not the
YAML-like source behind it (that's for the technical-round walkthrough, not
this one). Don't apologize if the agent asks a clarifying question instead
of answering immediately — that's the "never guess" guardrail working
correctly, say so if it happens.

## Verification note (for the presenter, not the audience)

The three actions above were run end-to-end against the live org and the
seeded `SO-00001` dataset via `Flow.Interview` (bypassing the conversational
layer) to confirm every output used in this script is real, not
illustrative — see `../scripts/apex/test-agent-flows.apex`. Confirmed
outputs: `found=true`, `stage=Provisioning`, `hasBlockingTasks=true`,
`blockingTaskSummary="PT-00002 (Equipment Install, status Blocked, due
2026-07-13); "`; pending-tasks list matches PT-00002 + PT-00003; the
not-found case for `SO-99999` returns `found=false` with the correct
message; escalation creates a real Case + Escalation Log and returns a
clean confirmation. The live conversational preview/publish step
(`sf agent preview`, `sf agent publish authoring-bundle`) is pending in this
environment due to a network path issue reaching Salesforce's Einstein
preview API (`test.api.salesforce.com`) — every other Salesforce endpoint,
including this org itself, is reachable. Once that's resolved, this script
should be re-walked live and screen-recorded rather than read from this
document.
