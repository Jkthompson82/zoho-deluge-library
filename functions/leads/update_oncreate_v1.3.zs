// ============================================================
// 🔧 Function Name : updateLeadOnCreate
// 🧾 Description   : On lead creation, updates Product Interest, Lead Source, SOA, DNC logic, ZIP, and Consent End Date.
// 👤 Author        : Jason Thompson
// 📅 Version       : 1.3
// 🗓️ Last Updated  : 04/17/2025
// 📌 Notes         : Runs once via workflow on create. DNC logic applies to all leads, including CompletedProcessing.
// ============================================================

leadId = id.toLong();
leadData = zoho.crm.getRecordById("Leads", leadId);
updateMap = Map();

// === ZIP Code — Trim to 5 Digits ===
zipRaw = leadData.get("Zip_Code");
if (zipRaw != null && zipRaw.length() >= 5)
{
    updateMap.put("Zip_Code", zipRaw.getPrefix(5));
}

// === Campaign Logic ===
campaignId = leadData.get("Campaign_Name");
if (campaignId != null && campaignId.contains("Direct_Mail_Responder_Deliver_Guide") && campaignId.contains("MedSupp_Pre65"))
{
    updateMap.put("Lead_Type", "T65 Medicare Supplement");
    updateMap.put("Lead_Source", "Physician Mutual Direct Mail");
    updateMap.put("SOA_Complete", "Not Required");
}

// === DNC Checkbox ===
if (leadData.get("Do_Not_Call_Flag") == "DoNotCall")
{
    updateMap.put("DNC", true);
}
else if (leadData.get("Do_Not_Call_Flag") == "CompletedProcessing")
{
    updateMap.put("DNC", false);
}

// === Can Call? Logic ===
dncTrigger = leadData.get("Do_Not_Call_Flag");
consentDate = leadData.get("DNC_Last_Checked_Date");

if (dncTrigger != null && consentDate != null)
{
    if (dncTrigger == "DoNotCall" || dncTrigger == "CompletedProcessing")
    {
        updateMap.put("Can_Call", "Yes");
    }
}
else
{
    updateMap.put("Can_Call", "DNC Needs Rechecked");
}

// === 60 Day Consent End Date ===
if (consentDate != null)
{
    consentEnd = consentDate.addDay(59);
    updateMap.put("Day_Consent_End_Date", consentEnd);
}

// === Push Update ===
if (!updateMap.isEmpty())
{
    updateResp = zoho.crm.updateRecord("Leads", leadId, updateMap);
    info updateResp.toString();
}
