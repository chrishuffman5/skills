# Clarify Phase: Structured Ambiguity Resolution

This reference defines the complete workflow for running a structured clarification session to reduce spec ambiguity and strengthen a feature specification.

---

## Overview

The clarify phase takes an existing specification and systematically:
- Scans it for ambiguities across a defined taxonomy
- Generates a prioritized queue of up to 5 clarification questions
- Presents questions one at a time with recommended answers
- Integrates each answer directly into the spec
- Records all clarifications in a session log

The goal is maximum information gain with minimum user effort.

---

## Hard Rules

These rules are non-negotiable:

1. **Maximum 5 questions total.** Never exceed this. If more ambiguities exist, resolve the least impactful ones with reasonable defaults.
2. **One question at a time.** Never reveal upcoming questions or the total queue.
3. **Every question must be answerable with multiple-choice or 5 words or fewer.** If a question requires a paragraph to answer, it is too broad. Break it down or rephrase.
4. **Only ask questions that materially impact architecture, data modeling, task decomposition, or compliance.** If the answer would not change how the feature is built or validated, do not ask it.
5. **Never reveal the remaining question queue.** The user should only see the current question.

---

## Step-by-Step Workflow

### Step 1: Load the Existing Spec

Read the spec from `specs/<feature-name>/spec.md`. Confirm the file exists and parse its current contents. If the spec does not exist, stop and inform the user to run the specify phase first.

Also check for any existing clarification sessions in the spec (look for a `## Clarifications` section). If prior sessions exist, account for already-resolved questions and do not re-ask them.

### Step 2: Perform Structured Ambiguity Scan

Systematically scan the spec against each of the following 10 taxonomy categories. For each category, identify specific ambiguities, missing information, or unstated assumptions.

#### Taxonomy Categories

| # | Category | What to look for |
|---|---|---|
| 1 | **Functional Scope** | Unclear boundaries, missing features implied but not stated, vague "and more" language, undefined behavior for edge inputs |
| 2 | **Domain/Data Model** | Undefined entities, unclear relationships between entities, missing attributes, ambiguous cardinality (one-to-many vs. many-to-many), unclear data lifecycle |
| 3 | **Interaction/UX** | Undefined user flows, unclear navigation, missing states (loading, empty, error), ambiguous input validation rules, unspecified feedback mechanisms |
| 4 | **Non-Functional Quality** | Missing or vague performance expectations, undefined scalability needs, unclear availability requirements, unspecified data volume expectations |
| 5 | **Integration/Dependencies** | Undefined external systems, unclear API contracts, missing authentication/authorization for integrations, unspecified data sync behavior |
| 6 | **Edge Cases/Failure Handling** | Missing error scenarios, undefined recovery behavior, unclear timeout handling, unspecified behavior under load, race condition potential |
| 7 | **Constraints/Tradeoffs** | Unstated budget/timeline constraints, unclear priority between competing qualities (speed vs. accuracy, simplicity vs. flexibility), missing regulatory requirements |
| 8 | **Terminology** | Ambiguous domain terms used inconsistently, undefined acronyms, terms that could mean different things to different stakeholders |
| 9 | **Completion Signals** | Unclear definition of done, missing acceptance thresholds, undefined rollout criteria, ambiguous success measurement |
| 10 | **Misc/Placeholders** | Any `[NEEDS CLARIFICATION]` markers, TODO comments, placeholder text, sections marked as TBD |

For each ambiguity found, record:
- The taxonomy category
- The specific text or section in the spec
- Why it matters (what decisions depend on resolving it)
- The impact level: **Critical** (blocks architecture/data model), **High** (affects task decomposition), **Medium** (affects implementation details), **Low** (cosmetic or easily reversible)

### Step 3: Generate the Prioritized Question Queue

From all identified ambiguities, select up to 5 questions. Prioritize by:

1. **Critical impact first.** Questions that block architecture or data modeling decisions.
2. **Information gain.** Questions whose answers resolve multiple ambiguities at once.
3. **Dependency chain.** Questions whose answers unlock or change subsequent questions.
4. **Risk reduction.** Questions that address security, compliance, or data integrity concerns.

For each question, prepare:
- The question text (clear, concise, jargon-free)
- A recommended answer with reasoning
- For multiple-choice: 3-5 options labeled A through E
- For short-answer: a suggested default answer
- Which spec sections will be updated based on the answer
- Which taxonomy category it addresses

**Drop any question that fails the materiality test:** "If I got this answer wrong, would it change how the feature is built or validated?" If no, do not ask it.

### Step 4: Present Questions One at a Time

#### Multiple-Choice Format

```markdown
**Question 1 of N**

<Clear, specific question>

**Recommended: Option B** - <Brief reasoning for why this is the best default>

| Option | Description |
|---|---|
| A | <option description> |
| B | <option description> (recommended) |
| C | <option description> |
| D | <option description> |

You can reply with a letter, or type your own answer. Say **"yes"** to accept the recommendation.
```

#### Short-Answer Format

```markdown
**Question 1 of N**

<Clear, specific question>

**Suggested answer:** <reasonable default>

You can accept this by saying **"yes"**, or provide your own answer (5 words or fewer).
```

Rules for presenting:
- Show the question number but NOT the total remaining (e.g., "Question 1" not "Question 1 of 5")
- Always provide a recommended/suggested answer so the user can simply say "yes"
- Keep question text to 1-2 sentences maximum
- Do not explain why you are asking unless the question would be confusing without context

### Step 5: Integrate Each Answer

After receiving the user's answer to each question, immediately:

1. **Parse the answer.** Map "yes" to the recommended option. Map letter choices to the corresponding option. Parse short answers directly.

2. **Update the spec.** Modify the appropriate sections in `specs/<feature-name>/spec.md`:

   | Answer affects... | Update these sections |
   |---|---|
   | Feature scope | User Scenarios, Functional Requirements, scope boundaries |
   | Data model | Key Entities, related Functional Requirements |
   | User experience | User Scenarios, Acceptance Criteria |
   | Non-functional quality | Success Criteria, Assumptions |
   | Integration | Functional Requirements, Assumptions, Key Entities |
   | Edge cases | User Scenarios (add error path scenarios), Functional Requirements |
   | Constraints | Assumptions, Success Criteria |
   | Terminology | All sections (find and replace ambiguous terms) |
   | Completion signals | Success Criteria |
   | Placeholders | Replace the specific `[NEEDS CLARIFICATION]` marker |

3. **Remove any `[NEEDS CLARIFICATION]` markers** that are resolved by this answer.

4. **Add to the Clarifications log** (see Step 6).

5. **Save the spec** to disk immediately after each integration. Do not batch saves.

6. **Re-evaluate the remaining question queue.** The user's answer may:
   - Render a queued question unnecessary (skip it)
   - Change the best phrasing of a queued question (update it)
   - Reveal a new ambiguity that is more important (replace a queued question)

### Step 6: Maintain the Clarifications Log

Add or append to a `## Clarifications` section at the end of the spec (before any existing appendices):

```markdown
## Clarifications

### Session <YYYY-MM-DD>

- **Q1 (Functional Scope):** <question text>
  **A:** <answer text>
  **Updated:** <list of sections modified>

- **Q2 (Domain/Data Model):** <question text>
  **A:** <answer text>
  **Updated:** <list of sections modified>
```

Each entry records:
- The question number and taxonomy category
- The question as asked
- The user's answer (or "Accepted recommendation: <text>")
- Which spec sections were updated

### Step 7: Determine When to Stop

Stop the clarification session when ANY of these conditions is met:

| Condition | Action |
|---|---|
| All critical and high ambiguities are resolved | Stop, report success |
| User says "done", "stop", "that's enough", or similar | Stop, report current state |
| 5 questions have been asked | Stop, report current state |
| No remaining ambiguities pass the materiality test | Stop, report success |

When stopping early (user request or question limit), resolve remaining medium/low ambiguities with reasonable defaults and note them in Assumptions.

### Step 8: Report Completion

After the session ends, provide a summary:

```markdown
Clarification session complete.

  Spec: specs/<feature-name>/spec.md
  Questions asked: <N> of 5 maximum

  **Taxonomy Coverage:**
  | Category | Status |
  |---|---|
  | Functional Scope | Resolved / No issues / Not addressed |
  | Domain/Data Model | Resolved / No issues / Not addressed |
  | Interaction/UX | Resolved / No issues / Not addressed |
  | Non-Functional Quality | Resolved / No issues / Not addressed |
  | Integration/Dependencies | Resolved / No issues / Not addressed |
  | Edge Cases/Failure Handling | Resolved / No issues / Not addressed |
  | Constraints/Tradeoffs | Resolved / No issues / Not addressed |
  | Terminology | Resolved / No issues / Not addressed |
  | Completion Signals | Resolved / No issues / Not addressed |
  | Misc/Placeholders | Resolved / No issues / Not addressed |

  **Sections updated:** <list of spec sections that were modified>
  **Remaining ambiguities:** <N> (resolved with defaults in Assumptions)
  **NEEDS CLARIFICATION markers remaining:** <N>

Next steps:
  - /spec-kit clarify   Run another clarification session
  - /spec-kit plan      Decompose into implementation tasks
```

---

## Question Quality Guidelines

### Good Questions (ask these)

- "Should reports be exportable by all users or only admins?"
  - Why: Scope and authorization impact. Changes data model and access control requirements.
- "Are notifications needed in real-time or is a daily digest acceptable?"
  - Why: Architecture impact. Real-time vs. batch changes infrastructure decisions significantly.
- "Should deleted items be recoverable (soft delete) or permanently removed?"
  - Why: Data model impact. Affects storage, compliance, and UI design.

### Bad Questions (never ask these)

- "What color should the button be?"
  - Why: Does not impact architecture, data model, or task decomposition. Pure design detail.
- "Should we use PostgreSQL or MongoDB?"
  - Why: Implementation detail. The spec is technology-agnostic.
- "Do you want unit tests?"
  - Why: Not a spec concern. Testing strategy is an implementation decision.
- "What should the error message say when X fails?"
  - Why: Too granular. The spec should say "user-friendly error message" and leave the copy to implementation.

### Borderline Questions (ask only if Critical/High impact)

- "Should the search support fuzzy matching?"
  - When to ask: If the feature is primarily a search feature and this changes scope significantly.
  - When to skip: If search is a minor supporting function. Default to exact match with a note in Assumptions.
- "Should the feature support offline use?"
  - When to ask: If the user mentioned mobile or field workers.
  - When to skip: If context clearly implies desktop/web. Default to online-only.

---

## Handling Difficult Situations

### User gives a vague answer

If the user responds with something ambiguous like "whatever works" or "you decide":
- Accept it as delegation. Choose the recommended option.
- Integrate it and note "Deferred to implementation default" in the Clarifications log.
- Move to the next question. Do not re-ask.

### User wants to change a previous answer

- Update the spec to reflect the new answer.
- Update the Clarifications log with a note: "Revised from previous answer."
- This does NOT count as an additional question against the 5-question limit.

### User raises a new topic not in the queue

- If it is a valid ambiguity, integrate the information into the spec immediately.
- This does NOT count as a question against the 5-question limit (the user volunteered it).
- Re-evaluate remaining queued questions in light of the new information.

### Spec has no significant ambiguities

If the ambiguity scan finds no Critical or High issues:
- Do not force questions. Report that the spec is clear.
- Optionally mention 1-2 Medium/Low items the user might want to think about, but do not require answers.
