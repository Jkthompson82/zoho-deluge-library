
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







*****Notes from last script from CoPilot****************
# Common Zoho Deluge Syntax & Coding Mistakes

## 1. Incorrect Function Header Format
- **Mistake:** Writing the function header without a namespace or with the wrong format.
  - ❌ `void myfunction(string a, string b) { ... }`
- **Correct:** Use the required namespace (e.g., `crm.`, `automation.`, or your app/module name):
  - ✅ `void crm.myfunction(string a, string b) { ... }`
  - ✅ `void automation.dialer_version(string leadId, ...) { ... }`

## 2. Using Unsupported Data Types
- **Mistake:** Using data types not supported by Deluge (e.g., `int`, `boolean` instead of `long`, `bool`).
  - ❌ `int x = 5;`
- **Correct:** Use only supported types: `string`, `long`, `bool`, `map`, `list`, etc.
  - ✅ `long x = 5;`

## 3. Not Using Map/List Properly
- **Mistake:** Forgetting to use `map()` or `list()` when creating new collections.
  - ❌ `myMap = {};`
  - ❌ `myList = [];`
- **Correct:** Use Deluge's constructors.
  - ✅ `myMap = map();`
  - ✅ `myList = list();`

## 4. String Concatenation Errors
- **Mistake:** Using `+` for string and variable concatenation without converting variables to string.
  - ❌ `"Value: " + variable` (if variable is not a string)
- **Correct:** Always use `.toString()` for non-string variables.
  - ✅ `"Value: " + variable.toString()`

## 5. Field Name Case Sensitivity
- **Mistake:** Using incorrect capitalization for field (API) names or using field labels instead of API names.
  - ❌ `data.put("FirstName", value);`
- **Correct:** Use the exact API name from Zoho.
  - ✅ `data.put("First_Name", value);`

## 6. Improper Use of Return Statements
- **Mistake:** Returning a value in a `void` function.
  - ❌ `return result;` in a `void` function
- **Correct:** Only use `return` in functions with a return type.

## 7. Forgetting to Commit/Save Script Changes
- **Mistake:** Editing or adding code but not saving or committing changes before testing.

## 8. Failing to Handle Null Values
- **Mistake:** Not checking if a variable is null before using it, leading to runtime errors.
  - ❌ `info variable.length();`
- **Correct:** Always check for null if not sure.
  - ✅ `if (variable != null) { info variable.length(); }`

## 9. Incorrect Use of API Calls
- **Mistake:** Using wrong module or field names in CRM API calls.
  - ❌ `zoho.crm.createRecord("Lead", data);`
- **Correct:** Use the correct module and field names as per Zoho CRM API.
  - ✅ `zoho.crm.createRecord("Leads", data);`

## 10. Syntax Errors with Parentheses/Braces
- **Mistake:** Missing or extra parentheses `{}` or `()`.
  - ❌ `if (a == b) info "Match";`
- **Correct:** Always wrap code blocks with braces.
  - ✅ `if (a == b) { info "Match"; }`

---

## Tips
- Always refer to Zoho's API documentation for exact field/module names.
- Use info logs (`info "message";`) liberally to debug.
- Use the built-in script validator in Zoho to catch common syntax issues.

