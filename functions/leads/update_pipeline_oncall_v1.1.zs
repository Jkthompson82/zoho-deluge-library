// ============================================================
// 🔧 Function Name : update_pipeline_oncall
// 🧾 Description   : Triggered when a call is logged. Updates pipeline fields on Lead.
// 👤 Author        : Jason Thompson
// 📅 Version       : 1.1
// 🗓️ Last Updated  : 04/17/2025
// ============================================================

// Input: id (string from Calls module)
callId = input.id.toLong();
info "🚀 Triggered for Call ID: " + callId;

// Fetch Call record
callInfo = zoho.crm.getRecordById("Calls", callId);
if (callInfo == null)
{
    info "❌ Call record not found. Exiting.";
    return;
}

// Get Lead ID from What_Id safely
leadRef = ifnull(callInfo.get("What_Id"), null);
if (leadRef == null)
{
    info "❌ No What_Id found — not linked to a Lead. Exiting.";
    return;
}
leadId = leadRef.get("id");
info "✅ Lead ID: " + leadId;

// Get completed pipeline step
completedStep = ifnull(callInfo.get("Diriect_Mail_Pipeline_Step_Competed"), "");
if (completedStep == "")
{
    info "❌ No pipeline step completed. Exiting.";
    return;
}

// Define ordered pipeline stages
pipeline = list();
pipeline.add("Stage 1 – (Day 1) No Voicemail / No Text");
pipeline.add("Stage 2 – (Day 2) No Voicemail / No Text");
pipeline.add("Stage 3 – (Day 3) Voicemail 1 + Text 1 (Confirm Request)");
pipeline.add("Stage 4 – (Day 6) No Voicemail / No Text");
pipeline.add("Stage 5 – (Day 8) Voicemail 2 + Text 2 (Expanded Confirm Request – send to email or house)");
pipeline.add("Stage 6 – (Day 10) No Voicemail / No Text");
pipeline.add("Stage 7 – (Day 12) No Voicemail / No Text");
pipeline.add("Stage 8 – (Day 15) Voicemail 3 + Text 3 (Still have your request – send to email or house)");
pipeline.add("Stage 9 – (Day 19) No Voicemail / No Text");
pipeline.add("Stage 10 – (Day 22) No Voicemail / No Text");
pipeline.add("Stage 11 – (Day 23) Send Email (Guide + About Me PDF) + Voicemail 4 + Text 4 (Email sent early morning)");
pipeline.add("Stage 12 – (Day 30) Send Follow-Up Email 1");
pipeline.add("Stage 13 – (Day 31) Voicemail 5 + Text 5 (Checking in)");
pipeline.add("Stage 14 – (Day 37) Send Follow-Up Email 2");
pipeline.add("Stage 15 – (Day 38) Voicemail 6 + Text 6 (Re-engagement)");
pipeline.add("Stage 16 – (Day 45) Final Voicemail 7 + Final Text 7 + Send Email 2 (Close out the request)");
pipeline.add("Stage 17– Contact-Set Appointment-End Campaign");
pipeline.add("Stage 18 – Contact-No Appointment Send Guide/Follow Up-End Campaign");
pipeline.add("Stage 19 – Contact-Not Interested-End Campaign");

// Define day gaps between stages
gapMap = map();
gapMap.put("Stage 1 – (Day 1) No Voicemail / No Text", 1);
gapMap.put("Stage 2 – (Day 2) No Voicemail / No Text", 1);
gapMap.put("Stage 3 – (Day 3) Voicemail 1 + Text 1 (Confirm Request)", 3);
gapMap.put("Stage 4 – (Day 6) No Voicemail / No Text", 2);
gapMap.put("Stage 5 – (Day 8) Voicemail 2 + Text 2 (Expanded Confirm Request – send to email or house)", 2);
gapMap.put("Stage 6 – (Day 10) No Voicemail / No Text", 2);
gapMap.put("Stage 7 – (Day 12) No Voicemail / No Text", 3);
gapMap.put("Stage 8 – (Day 15) Voicemail 3 + Text 3 (Still have your request – send to email or house)", 4);
gapMap.put("Stage 9 – (Day 19) No Voicemail / No Text", 3);
gapMap.put("Stage 10 – (Day 22) No Voicemail / No Text", 1);
gapMap.put("Stage 11 – (Day 23) Send Email (Guide + About Me PDF) + Voicemail 4 + Text 4 (Email sent early morning)", 7);
gapMap.put("Stage 12 – (Day 30) Send Follow-Up Email 1", 1);
gapMap.put("Stage 13 – (Day 31) Voicemail 5 + Text 5 (Checking in)", 6);
gapMap.put("Stage 14 – (Day 37) Send Follow-Up Email 2", 1);
gapMap.put("Stage 15 – (Day 38) Voicemail 6 + Text 6 (Re-engagement)", 7);
gapMap.put("Stage 16 – (Day 45) Final Voicemail 7 + Final Text 7 + Send Email 2 (Close out the request)", 0);

// Determine next step
idx = pipeline.indexOf(completedStep);
if (idx == -1)
{
    info "❌ Completed step not found in pipeline. Exiting.";
    return;
}
nextStep = if(idx + 1 < pipeline.size(), pipeline.get(idx + 1), null);

// Calculate next date
gapDays = ifnull(gapMap.get(completedStep), 0);
nextCallDate = if(gapDays > 0, zoho.currentdate.addDay(gapDays), null);

// Use call's actual start time for last call field
callStartTime = callInfo.get("Call_Start_Time");

// Prepare update
updateMap = map();
updateMap.put("Direct_Mail_Pipeline_Next_Step", nextStep);
updateMap.put("Last_Call_Date_Time", callStartTime);
if (nextCallDate != null)
{
    updateMap.put("Next_Date_to_Call", nextCallDate);
}
if (completedStep == "Stage 1 – (Day 1) No Voicemail / No Text")
{
    updateMap.put("Lead_Status", "Attempted to Contact");
}

// Final update
updateResp = zoho.crm.updateRecord("Leads", leadId.toLong(), updateMap);
info "✅ Lead updated:";
info updateResp.toString();
