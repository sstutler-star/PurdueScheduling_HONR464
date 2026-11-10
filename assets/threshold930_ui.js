/* Displays the main-analysis 9:30 AM threshold as a *separate* robustness panel.
   Does not overwrite or re-render the user's baseline results, authored content,
   abstracts, appendices, original code or lecture-only data. */
(() => {
  'use strict';
  document.addEventListener('DOMContentLoaded', () => {
    const d = window.RESEARCH_DATA;
    const r = d?.cutoff930;
    const content = document.querySelector('section.page[data-view="checks"] .content');
    if (!r || !content || document.getElementById('cutoff930Panel')) return;
    const style = document.createElement('style');
    style.textContent = `
      #cutoff930Panel{margin-top:34px;color:#302725}
      #cutoff930Panel h2{color:#632523;margin:0 0 8px}
      #cutoff930Panel h3{color:#632523;margin:0 0 8px}
      #cutoff930Panel p{line-height:1.7}
      .cutoff-intro{background:#fff;border-left:5px solid #632523;border-radius:7px;padding:18px 22px;margin:19px 0;color:#41362e}
      .cutoff-panel{background:#fff;border:1px solid #e4d9d2;border-radius:9px;padding:18px;margin:15px 0}
      .cutoff-fields{display:flex;flex-wrap:wrap;gap:13px;align-items:end;margin:0 0 17px}
      .cutoff-fields label{display:flex;flex-direction:column;gap:7px;font-size:12px;font-weight:700;color:#632523}
      .cutoff-fields select,.cutoff-fields input{height:42px;min-width:190px;max-width:100%;border:1px solid #cdbab0;border-radius:6px;padding:0 11px;background:#fff;color:#302725}
      .cutoff-scroll{overflow:auto}
      .cutoff-scroll table{width:100%;min-width:750px;border-collapse:collapse;background:#fff;font-size:12px}
      .cutoff-scroll th{background:#632523;color:#fff;text-align:left;padding:11px 10px;white-space:nowrap}
      .cutoff-scroll td{color:#302725;padding:9px 10px;border-bottom:1px solid #ede5df;white-space:nowrap}
      .cutoff-scroll tr:nth-child(even){background:#faf7f4}
      .cutoff-pages{display:flex;align-items:center;gap:12px;justify-content:flex-end;margin:12px 0 4px;font-size:12px}
      .cutoff-pages button{border:1px solid #632523;border-radius:5px;padding:7px 11px;background:#fff;color:#632523;cursor:pointer}
      .cutoff-pages button:disabled{opacity:.43;cursor:default}
      .cutoff-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:15px;margin:15px 0}
      .cutoff-plot{background:#fff;border:1px solid #e0d6d0;border-radius:8px;padding:16px;min-width:0}
      .cutoff-plot svg{width:100%;height:auto;display:block}
      .cutoff-plot .subheading{color:#75635a;font-size:12px;margin:0 0 8px}
      .cutoff-downloads{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:10px;margin:16px 0}
      .cutoff-downloads a{border:1px solid #e0d4ce;background:#fff;color:#632523;padding:14px;border-radius:6px;text-decoration:none;font-weight:650;font-size:12px}
      .cutoff-downloads a:hover{background:#fff6f5;border-color:#953735}
      @media(max-width:800px){.cutoff-grid{grid-template-columns:1fr}.cutoff-fields select,.cutoff-fields input{min-width:0}}
    `;
    document.head.appendChild(style);
    const section = document.createElement('section');
    section.id = 'cutoff930Panel';
    section.innerHTML = `
      <h2>9:30 AM threshold robustness check</h2>
      <p>Same main-analysis section population, with the early-start cutoff changed to 9:30 AM. View this specification separately from both the baseline 9 AM analysis and the lecture-only 9 AM analysis.</p>
      <div class="cutoff-intro"><b>Measurement definition:</b> MATLAB labels the fourth interval metric “Outside 9-to-5,” but its morning component changes with this sensitivity run. Here it is labeled <strong>outside 9:30 AM–5:00 PM</strong> to prevent confusion. Average start times, section counts and after-5 PM outcomes are unaffected by the morning cutoff. The college intervals use <strong>99.9%</strong> confidence; significant intervals exclude zero.</div>
      <h3>College difference intervals (9:30 AM specification)</h3>
      <div class="cutoff-fields"><label>Focal college<select id="cutoff930College"></select></label><span id="cutoff930Count" style="font-size:12px;color:#785f54"></span></div>
      <div id="cutoff930Plots" class="cutoff-grid"></div>
      <h3 style="margin-top:30px">9:30 AM subject, college and semester results</h3>
      <div class="cutoff-panel">
        <div class="cutoff-fields">
          <label>Table<select id="cutoff930TableSelect">
            <option value="college-combined">Combined college statistics</option>
            <option value="college-f26">Fall 2026 colleges</option>
            <option value="college-s26">Spring 2026 colleges</option>
            <option value="subject-f26">Fall 2026 subjects</option>
            <option value="subject-s26">Spring 2026 subjects</option>
            <option value="semester">Semester differences (20+ sections)</option>
          </select></label>
          <label>Search<input type="search" id="cutoff930Search" placeholder="College or subject name"></label>
          <span id="cutoff930Rows" style="font-size:12px;color:#785f54" aria-live="polite"></span>
        </div>
        <div class="cutoff-scroll" id="cutoff930Table"></div>
        <div class="cutoff-pages"><button type="button" id="cutoff930Prev">Previous</button><span id="cutoff930Page"></span><button type="button" id="cutoff930Next">Next</button></div>
      </div>
      <h3 style="margin-top:30px">Download the complete 9:30 AM results</h3>
      <div class="cutoff-downloads" id="cutoff930Downloads"></div>
      <p style="color:#755e53;font-size:12px">The interval diagrams report each comparison *within this specification*. Their confidence bounds should not be pooled with other specifications. Approximate numerators are reconstructed from rounded summary proportions; the MATLAB TXT does not include standard deviations in the summary table.</p>
    `;
    content.appendChild(section);
    const pick = s => section.querySelector(s);
    const cols = r.colleges.combined.map(row => row.college);
    const college = pick('#cutoff930College');
    for (const name of cols) {
      const option = document.createElement('option'); option.value = name; option.textContent=name; college.appendChild(option);
    }
    const metrics = [
      ['before9','Before 9:30 AM'],['after5','After 5 PM'],
      ['outside','Outside 9:30 AM–5 PM'],['start','Average start time']
    ];
    const esc = s => String(s??'—').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
    function plotFor(name,metric,label) {
      const values = r.intervals.filter(x => x.metric === metric && (x.college===name||x.other===name)).map(x =>
        x.college===name?{other:x.other,low:x.lower,high:x.upper,estimate:x.estimate}:{other:x.college,low:-x.upper,high:-x.lower,estimate:-x.estimate}
      );
      if (!values.length) return '<p>No data.</p>';
      const W=580,LEFT=178,RIGHT=24,TOP=28,STEP=30,HEIGHT=TOP+STEP*values.length+37;
      let lo=Math.min(0,...values.map(x=>x.low)),hi=Math.max(0,...values.map(x=>x.high));
      const pad=(hi-lo||1)*.12;lo-=pad;hi+=pad;
      const x = v => LEFT+(v-lo)/(hi-lo)*(W-LEFT-RIGHT);
      let svg=`<svg viewBox="0 0 ${W} ${HEIGHT}" role="img" aria-label="${esc(label)}: ${esc(name)} college difference intervals"><line x1="${x(0)}" x2="${x(0)}" y1="12" y2="${HEIGHT-26}" stroke="#948a83" stroke-dasharray="4 4"/>`;
      values.forEach((v,i) => {
        const y=TOP+i*STEP;const significant=v.low>0||v.high<0;const color=significant?'#953735':'#666666';
        const detail=metric==='start'? v.low.toFixed(1)+' to '+v.high.toFixed(1)+' minutes':(100*v.low).toFixed(2)+' to '+(100*v.high).toFixed(2)+' percentage points';
        svg+=`<g><title>${esc(name)} minus ${esc(v.other)}: ${esc(detail)}</title><text x="${LEFT-12}" y="${y+4}" text-anchor="end" fill="#392a23" font-size="11">${esc(v.other)}</text><line x1="${x(v.low)}" y1="${y}" x2="${x(v.high)}" y2="${y}" stroke="${color}" stroke-width="2"/><line x1="${x(v.low)}" x2="${x(v.low)}" y1="${y-4}" y2="${y+4}" stroke="${color}" stroke-width="2"/><line x1="${x(v.high)}" x2="${x(v.high)}" y1="${y-4}" y2="${y+4}" stroke="${color}" stroke-width="2"/><circle cx="${x(v.estimate)}" cy="${y}" r="2.5" fill="${color}"/></g>`;
      });
      const fmt = t => metric==='start'?t.toFixed(1):(t*100).toFixed(1)+' pp';
      svg+=`<text x="${LEFT}" y="${HEIGHT-8}" font-size="10" fill="#77665d">${fmt(lo)}</text><text x="${W-RIGHT}" y="${HEIGHT-8}" text-anchor="end" font-size="10" fill="#77665d">${fmt(hi)}</text></svg>`;
      return svg;
    }
    const plotWrap=pick('#cutoff930Plots');
    function renderPlots() {
      const name=college.value;
      plotWrap.textContent='';
      for(const [key,label] of metrics){
        const card=document.createElement('div');card.className='cutoff-plot';
        const h=document.createElement('h3');h.textContent=label;card.appendChild(h);
        const sub=document.createElement('p');sub.className='subheading';sub.textContent=`${name} versus other colleges · red = excludes zero`;
        card.appendChild(sub);
        // SVG is constructed from the numeric data and known metric labels; college names are escaped.
        const box=document.createElement('div');box.innerHTML=plotFor(name,key,label);card.appendChild(box);
        plotWrap.appendChild(card);
      }
      pick('#cutoff930Count').textContent=`${r.intervals.filter(x=>x.college===name||x.other===name).length} interval records for this college`;
    }
    college.addEventListener('change',renderPlots);
    renderPlots();
    const tablePick=pick('#cutoff930TableSelect');
    const search=pick('#cutoff930Search');
    let page=0;
    const tableCols=[['name','Name'],['sections','# Sections'],['meanStart','Mean start'],['before9Count','Before 9:30 #'],['before9Prop','Before 9:30 %'],['after5Count','After 5 #'],['after5Prop','After 5 %'],['outsideCount','Outside #'],['outsideProp','Outside %']];
    const semesterCols=[['subject','Subject'],['f26Sections','Fall #'],['s26Sections','Spring #'],['startPctChange','Start % change'],['before9PctChange','Morning % change'],['after5PctChange','Evening % change'],['outsidePctChange','Outside % change']];
    function rowsFor() {
      const selected=tablePick.value;
      if(selected==='semester') return r.semesterDifferences;
      const [lvl,sem]=selected.split('-');
      return r[lvl==='college'?'colleges':'subjects'][sem].map(x=>({...x,name:lvl==='college'?x.college:x.subject}));
    }
    function renderTable() {
      const q=search.value.trim().toLowerCase();
      const all=rowsFor().filter(row=> !q || Object.values(row).some(v=>String(v??'').toLowerCase().includes(q)));
      const c=tablePick.value==='semester'?semesterCols:tableCols;
      const per=50,pages=Math.max(1,Math.ceil(all.length/per));page=Math.min(page,pages-1);
      const curr=all.slice(page*per,(page+1)*per);
      const holder=pick('#cutoff930Table');holder.textContent='';
      if(!curr.length)holder.textContent='No matching records.';
      else{
        const t=document.createElement('table'),head=document.createElement('thead'),hrow=document.createElement('tr');
        c.forEach(([,label])=>{const th=document.createElement('th');th.textContent=label;hrow.appendChild(th)});
        head.appendChild(hrow);t.appendChild(head);
        const body=document.createElement('tbody');
        for(const row of curr){const tr=document.createElement('tr');for(const [key] of c){const td=document.createElement('td');td.textContent=String(row[key]??'—');tr.appendChild(td)}body.appendChild(tr)}
        t.appendChild(body);holder.appendChild(t);
      }
      pick('#cutoff930Rows').textContent=`${all.length} records`;
      pick('#cutoff930Page').textContent=`Page ${page+1} of ${pages}`;
      pick('#cutoff930Prev').disabled=page===0;
      pick('#cutoff930Next').disabled=page+1>=pages;
    }
    tablePick.addEventListener('change',()=>{page=0;renderTable()});
    search.addEventListener('input',()=>{page=0;renderTable()});
    pick('#cutoff930Prev').addEventListener('click',()=>{page--;renderTable()});
    pick('#cutoff930Next').addEventListener('click',()=>{page++;renderTable()});
    renderTable();
    const downloads=pick('#cutoff930Downloads');
    for(const item of r.downloads){
      const a=document.createElement('a');a.href=item.file;a.download='';a.textContent=item.label.replace(/^threshold930 /,'9:30 AM – ')+' ↓';downloads.appendChild(a);
    }
  });
})();
