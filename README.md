# learnnutrition-daily

Daily research briefs για το learnnutrition.gr (PubMed, μόνο ανθρώπινες μελέτες).

## ⚠️ ΟΔΗΓΙΕΣ ΓΙΑ ΚΑΘΕ AUTOMATED RUN — ΔΙΑΒΑΣΕ ΠΡΩΤΑ

**1. Πηγή αλήθειας:** Διάβασε το `research_config.json` ΠΡΙΝ από οτιδήποτε.
Περιέχει: κανόνες (μόνο άνθρωποι, de-dup), τις σταθερές ενότητες κάθε σελίδας,
οδηγίες μορφής (`format_rules`) και οδηγίες ανεβάσματος (`upload_instructions`).

**2. Μορφή:** Αναπαρήγαγε ΑΚΡΙΒΩΣ το υπάρχον template. Διάβασε ένα ήδη ανεβασμένο
αρχείο (π.χ. `research-inflammation.html` ή `research-weight.html`) και κράτα ίδιο
CSS/δομή: highlights box (📌), κάρτες με badge + τίτλο + πηγή + παραγράφους +
links (PubMed + DOI) + hook («🎣 Hook: «...»»). ΜΗΝ εφευρίσκεις νέο design.

**3. De-duplication:** Κάθε PMID πρέπει να ΜΗΝ υπάρχει στο `seen_pmids.json`.
Μετά το ανέβασμα, πρόσθεσε τα νέα PMID εκεί.

**4. ΑΝΕΒΑΣΜΑ — ΔΟΚΙΜΑΣΕ ΚΑΙ ΤΙΣ ΔΥΟ ΜΕΘΟΔΟΥΣ (ενημερώθηκε 5-8-2026):**
Η εγγραφή στο GitHub από το cloud environment είναι **ΑΣΤΑΘΗΣ** — η ανάγνωση
(`git clone`) δουλεύει πάντα, η εγγραφή όχι. Έχουν εμφανιστεί **δύο διαφορετικά**
403 σε διαφορετικές μέρες:
- API: `403 "Resource not accessible by integration"` (ο proxy αντικαθιστά το token)
- git push: `403 "GitHub access is not enabled for this session — an org admin must
  connect the Claude GitHub App"` (5-8-2026· την ίδια νύχτα, 74 λεπτά νωρίτερα, το git push
  είχε δουλέψει κανονικά)

Άρα **ΜΗ σταματάς στην πρώτη αποτυχία**. Σειρά:
1. **Μέθοδος Α — Contents API**: `PUT api.github.com/repos/<repo>/contents/<path>` με
   header `Authorization: Bearer <PAT>` (base64 content + `sha` του υπάρχοντος αρχείου).
2. **Μέθοδος Β — git push** (αν η Α δώσει 403). Έτοιμο script: **`./upload.sh`**
```bash
PAT=<fine_grained_token> ./upload.sh <local_file> <repo_path> "<commit message>"
```
Ισοδύναμα, χειροκίνητα:
```bash
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
git clone "https://x-access-token:<PAT>@github.com/savvastsanasidis-cell/learnnutrition-daily.git"
# copy files, git add, git commit, git push origin main
```
Το PAT μπαίνει ΜΕΣΑ στο git remote URL — ΟΧΙ ως API header. Δεν τυπώνεται ποτέ.

⚠️ **ΑΝ ΑΠΟΤΥΧΟΥΝ ΚΑΙ ΟΙ ΔΥΟ**: ΜΗΝ ενημερώσεις το `seen_pmids*.json` (αλλιώς τα PMIDs
χάνονται για πάντα από το de-dup), στείλε το HTML στον Σάββα ως αρχείο και ανέφερε το
ακριβές σφάλμα ΚΑΘΕ μεθόδου. Στο τέλος κάθε run γράψε ΠΟΙΑ μέθοδος πέτυχε.

## Αρχεία
- `research-weight.html` — Βάρος & Μεταβολισμός (4 ενότητες, βλ. config `weight_page`)
- `research-inflammation.html` — Φλεγμονή, Όργανα & Ορμόνες
- `research.html`, `ideas.html`, `recipes.html`, `qa.html`, `newsletter.html`
- `research_config.json` — ρυθμίσεις/μεθοδολογία (διαβάζεται κάθε run)
- `seen_pmids.json` — ιστορικό PMID για de-duplication
- `upload.sh` — uploader (git push, δουλεύει· το API όχι)
