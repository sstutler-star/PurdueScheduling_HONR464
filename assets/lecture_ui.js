/* Lecture-only supplementary interface for the existing Purdue scheduling website.
   Does not replace app.js or edit existing data. Load after assets/app.js. */
(() => {
  'use strict';
  document.addEventListener('DOMContentLoaded', () => {
    const d = window.RESEARCH_DATA;
    if (!d || !d.lectureOnly) return;
    const l = d.lectureOnly;
    const page = document.querySelector('section.page[data-view="lecture"] .content');
    if (!page || document.getElementById('lectureOnlyTables')) return;
    const css = document.createElement('style');
    css.textContent = `
      .lecture-notice { background:#fff7ee; color:#4b302e; border-left:5px solid #953735; border-radius:9px; padding:16px 20px; line-height:1.65; margin:18px 0; font-size:14px; }
      .lecture-notice strong { color:#632523; }
      .lecture-section { margin-top:32px; }
      .lecture-section h2 { color:#632523; margin:0 0 9px; }
      .lecture-section p { line-height:1.7; }
      .lecture-box { background:#fff; border:1px solid #e1d6d0; border-radius:14px; padding:20px; }
      .lecture-fields { display:flex; flex-wrap:wrap; gap:12px; align-items:end; margin-bottom:14px; }
      .lecture-fields label { display:flex; flex-direction:column; gap:5px; font-weight:650; font-size:12px; color:#632523; }
      .lecture-fields input, .lecture-fields select { min-height:39px; background:white; border:1px solid #c8b9b1; padding:7px 9px; border-radius:6px; color:#302725; max-width:100%; }
      .lecture-fields input { width:230px; }
      .lecture-scroll { overflow-x:auto; width:100%; border-radius:8px; }
      .lecture-scroll table { width:100%; border-collapse:collapse; background:#fff; font-size:12px; white-space:nowrap; }
      .lecture-scroll th { position:sticky; top:0; background:#632523; color:#fff; padding:11px 10px; text-align:left; }
      .lecture-scroll td { padding:9px 10px; border-bottom:1px solid #eee4df; color:#312825; }
      .lecture-scroll tr:nth-child(even) td {background:#faf7f5}
      .lecture-pages { display:flex; gap:12px; align-items:center; justify-content:flex-end; padding:14px 0 2px; font-size:12px; }
      .lecture-pages button { padding:7px 12px; border:1px solid #632523; border-radius:7px; background:white; color:#632523; cursor:pointer; }
      .lecture-pages button:disabled { opacity:.45; cursor:default; }
      .lecture-downloads { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:10px; }
      .lecture-downloads a { display:block; background:white; border:1px solid #e0d4ce; padding:13px 15px; border-radius:9px; color:#632523; text-decoration:none; font-weight:600; font-size:13px; }
      .lecture-downloads a:hover { border-color:#953735; background:#fff6f5; }
      .lecture-subtitle { color:#705e54; margin:4px 0 15px; }
      .lecture-mini-label { font-size:12px; font-weight:700; color:#632523; margin:0 0 6px; }
    `;
    document.head.appendChild(css);

    const notice = document.createElement('div');
    notice.className='lecture-notice';
    notice.innerHTML = `<strong>Comparable morning cutoffs:</strong> Both the baseline and corrected lecture-only analysis use <strong>before 9:00 AM</strong> for their morning measure and <strong>outside 9:00 AM–5:00 PM</strong> for the composite measure. The lecture-only specification changes the included section types, not the time threshold. Do not pool bounds from the two sets of difference intervals.`;
    const compare=page.querySelector('.compare-grid');
    if(compare) page.insertBefore(notice,compare);else page.prepend(notice);

    const section = document.createElement('section');
    section.id = 'lectureOnlyTables';
    section.className = 'lecture-section';
    section.innerHTML = `
      <h2>Lecture-only summary tables</h2>
      <p class="lecture-subtitle">Detailed lecture-only subject results, college results, and semester comparisons. Numbers come from the corrected 9 AM lecture-only MATLAB output. Numerators are estimates reconstructed from rounded proportions; standard deviations were not supplied.</p>
      <div class="lecture-box">
        <div class="lecture-fields">
          <label>Dataset<select id="lectureTableMode">
            <option value="college-combined">Combined college results</option>
            <option value="college-f26">Fall 2026 colleges</option>
            <option value="college-s26">Spring 2026 colleges</option>
            <option value="subject-f26">Fall 2026 subjects</option>
            <option value="subject-s26">Spring 2026 subjects</option>
            <option value="semester">Semester-to-semester differences (20+)</option>
          </select></label>
          <label>Search records<input id="lectureTableSearch" type="search" placeholder="College, subject, or value"></label>
          <span id="lectureTableCount" style="color:#705e54;font-size:12px" aria-live="polite"></span>
        </div>
        <div id="lectureTableView" class="lecture-scroll"></div>
        <div class="lecture-pages"><button type="button" id="lecturePrev">Previous</button><span id="lecturePageCounter"></span><button type="button" id="lectureNext">Next</button></div>
      </div>
      <h2 style="margin-top:32px">Download the lecture-only results</h2>
      <p class="lecture-subtitle">Full CSVs include all 264 college-level intervals and their 68 significant comparisons; the separate subject file contains the 8 reported significant subject intervals.</p>
      <div class="lecture-downloads" id="lectureDownloads"></div>
    `;
    page.appendChild(section);
    const downloadBox = section.querySelector('#lectureDownloads');
    const allDownloads = l.downloads;
    for (const entry of allDownloads) {
      const a=document.createElement('a');
      a.href=entry.file;
      a.setAttribute('download','');
      a.textContent=entry.label+' ↓';
      downloadBox.appendChild(a);
    }
    const tbl = section.querySelector('#lectureTableView');
    const mode=section.querySelector('#lectureTableMode');
    const search=section.querySelector('#lectureTableSearch');
    const count=section.querySelector('#lectureTableCount');
    const prev=section.querySelector('#lecturePrev');
    const next=section.querySelector('#lectureNext');
    const pageLabel=section.querySelector('#lecturePageCounter');
    let currentPage=0;
    const cols = [
      ['name','Name'],['sections','# Sections'],['meanStart','Mean start'],
      ['before9Count','Morning #'],['before9Prop','Morning %'],
      ['after5Count','After 5 #'],['after5Prop','After 5 %'],
      ['outsideCount','Outside #'],['outsideProp','Outside %'],['sdStart','Start SD']
    ];
    const changeCols = [
      ['subject','Subject'],['f26Sections','Fall #'],['s26Sections','Spring #'],
      ['startPctChange','Start time % change'],['before9PctChange','Morning % change'],
      ['after5PctChange','Evening % change'],['outsidePctChange','Outside % change']
    ];
    const sourceRows=()=>{
      const v=mode.value;
      if (v==='semester') return l.semesterDifferences||[];
      const [type,sem]=v.split('-');
      const arr=(type==='college'?l.colleges:l.subjects)?.[sem]||[];
      return arr.map(x=>({...x,name:type==='college'?x.college:x.subject}));
    };
    function render() {
      const isChanges=mode.value==='semester';
      const c=isChanges?changeCols:cols;
      const q=search.value.trim().toLowerCase();
      const all=sourceRows().filter(x=>!q||Object.values(x).some(v=>String(v??'').toLowerCase().includes(q)));
      const limit=50;
      const nPages=Math.max(1,Math.ceil(all.length/limit));
      currentPage=Math.max(0,Math.min(currentPage,nPages-1));
      const viewing=all.slice(currentPage*limit,(currentPage+1)*limit);
      tbl.textContent='';
      if (!viewing.length) tbl.textContent='No matching records.';
      else {
        const table=document.createElement('table');
        const thead=document.createElement('thead');const thr=document.createElement('tr');
        for(const [,label] of c){const th=document.createElement('th');th.textContent=label;thr.appendChild(th)}
        thead.appendChild(thr);table.appendChild(thead);
        const tbody=document.createElement('tbody');
        for(const row of viewing){const tr=document.createElement('tr');for(const [key] of c){const td=document.createElement('td');td.textContent=String(row[key]??'—');tr.appendChild(td)}tbody.appendChild(tr)}
        table.appendChild(tbody);tbl.appendChild(table);
      }
      count.textContent=`${all.length} records`;
      pageLabel.textContent=`Page ${currentPage+1} of ${nPages}`;
      prev.disabled=currentPage===0;
      next.disabled=currentPage+1>=nPages;
    }
    mode.addEventListener('change',()=>{currentPage=0;render()});
    search.addEventListener('input',()=>{currentPage=0;render()});
    prev.addEventListener('click',()=>{currentPage--;render()});
    next.addEventListener('click',()=>{currentPage++;render()});
    render();

    // The original app.js handles college and metric selections for both panels.
    // The corrected source is now Before 9 AM on both sides, so do not relabel charts.
  });
})();
