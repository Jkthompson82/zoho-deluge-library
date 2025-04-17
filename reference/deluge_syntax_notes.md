
# Deluge Syntax Notes & Working Patterns

This file is for storing clean, tested Deluge code blocks that are known to work in your CRM setup. It is meant to be a reference file for ChatGPT and future development.

## Structure
Each block should be grouped by function. Example groups might include:
- Create a task
- Update a lead or deal
- Schedule a call
- Assign an owner
- Search CRM records
- Date math
- Multi-step logic flows

## Rules for Adding Code
- Only paste code here **after it’s verified to work correctly**
- Add inline comments to explain what each line does
- Include any notes or “gotchas” (e.g., required fields, format issues)
- Never include example code that uses assumed API names
- Do not include generated code unless it has been tested

## Example Entry Format
> ✅ Title: What the code does  
> 💬 One-sentence description (optional)  
> 🧩 Code (pasted in fenced code block with `deluge` as the language)  
> 📝 Any follow-up notes, field name warnings, or reminders

---

## Notes
This file is read by ChatGPT before generating or editing code. Think of it as your master reference to prevent mistakes and speed up development.

If a script requires a new pattern or function, document it here once it’s confirmed working.


## ✅ Deluge Argument Standards  
**Version 1.0 — 04/17/2025**

All Deluge functions used in Zoho CRM **must define and map the record `id`** explicitly. This ensures:

- Better stability when executing functions from workflow rules or buttons  
- More accurate argument handling across modules  
- Cleaner debugging when referencing lead or contact records

---

### 🔧 Implementation Rules

- Every function should begin with:
  ```deluge
  // Arguments
  id = input.id.toLong();
-------

  Issue | Fix | Notes
❌ Used zoho.currenttime for DateTime field | ✅ Replaced with Call_Start_Time from call record | Zoho CRM requires full DateTime, not just time
❌ Tried to access Who_Id directly | ✅ Switched to What_Id.get("id") | Your calls are linked via What_Id
❌ Used invalid list/map syntax (list:List(), map:Map()) | ✅ Replaced with list() and map() | Deluge only supports standard initializers
❌ Used .get("id") without null check | ✅ Wrapped with ifnull(..., null) and validated existence before accessing | Prevented runtime error: 'get' function cannot be applied
🛠️ Optional fix: Ensured step advancement is dynamic | ✅ Pipeline and day gaps are now easily editable | Can handle skipped steps or final-stage exits
