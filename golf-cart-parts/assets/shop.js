(() => {
  'use strict';
  const { models, parts } = window.Pinrail;
  const view = document.body.dataset.view;
  const base = document.body.dataset.base;
  const params = new URLSearchParams(location.search);
  const itemById = new Map(parts.map(part => [part.slug, part]));
  const compact = value => String(value || '').toLowerCase().replace(/[^a-z0-9]/g, '');
  const listKey = 'pinrail.parts.v1';
  const get = (key, fallback) => {
    try { return JSON.parse(localStorage.getItem(key)) ?? fallback; }
    catch { return fallback; }
  };
  let memoryList = {};
  function readList() {
    const raw = get(listKey, memoryList);
    return Object.fromEntries(Object.entries(raw || {}).filter(([id, count]) =>
      itemById.has(id) && Number.isInteger(count) && count > 0 && count <= 99
    ));
  }
  function storeList(list) {
    memoryList = list;
    try { localStorage.setItem(listKey, JSON.stringify(list)); } catch { /* Session-only fallback. */ }
  }
  function updateCount() {
    const total = Object.values(readList()).reduce((sum, n) => sum + n, 0);
    document.querySelector('[data-count]').textContent = total;
    document.querySelector('.bag-link').ariaLabel = 'Parts list, ' + total + (total === 1 ? ' item' : ' items');
  }
  const price = value => new Intl.NumberFormat('en-US', {style:'currency', currency:'USD'}).format(value);
  const matches = (part, make, model, year) => part.fit.some(([id, start, end]) =>
    (!make || models[id].make === make) && (!model || id === model) &&
    (!year || (Number(year) >= start && Number(year) <= end))
  );
  function selectOptions(select, options, allLabel, preferred) {
    select.replaceChildren(new Option(allLabel, ''), ...options.map(([id, text]) => new Option(text, id)));
    if (options.some(([id]) => id === preferred)) select.value = preferred;
  }
  function fillFinder(finder) {
    const vehicle = finder.querySelector('[data-vehicle]');
    const number = finder.querySelector('[data-number]');
    const { make, model, year } = vehicle.elements;
    const yearOptions = () => {
      const candidates = Object.entries(models).filter(([k, item]) =>
        (!make.value || make.value === item.make) && (!model.value || model.value === k));
      const years = new Set();
      for (const [, item] of candidates) {
        for (let y = item.start; y <= item.end; y++) years.add(y);
      }
      return [...years].sort((a,b) => b-a).map(y => [String(y), String(y)]);
    };
    const modelOptions = () => Object.entries(models).filter(([, item]) => !make.value || item.make === make.value)
      .map(([id, item]) => [id, make.value ? item.name : item.make + ' ' + item.name]);
    const pickMode = mode => {
      vehicle.hidden = mode !== 'vehicle';
      number.hidden = mode !== 'number';
      for (const button of finder.querySelectorAll('[data-mode]')) button.setAttribute('aria-pressed', String(button.dataset.mode === mode));
    };
    make.value = params.get('make') || '';
    selectOptions(model, modelOptions(), 'All models', params.get('model'));
    selectOptions(year, yearOptions(), 'All years', params.get('year'));
    number.elements.q.value = params.get('q') || '';
    pickMode(params.get('q') ? 'number' : 'vehicle');
    make.addEventListener('change', () => {
      selectOptions(model, modelOptions(), 'All models', '');
      selectOptions(year, yearOptions(), 'All years', year.value);
    });
    model.addEventListener('change', () => {
      if (model.value && !make.value) {
        const id = model.value;
        make.value = models[id].make;
        selectOptions(model, modelOptions(), 'All models', id);
      }
      selectOptions(year, yearOptions(), 'All years', year.value);
    });
    for (const button of finder.querySelectorAll('[data-mode]')) button.addEventListener('click', () => {
      pickMode(button.dataset.mode);
      if (button.dataset.mode === 'number') number.elements.q.focus();
    });
    for (const form of [vehicle, number]) {
      form.addEventListener('submit', event => {
        event.preventDefault();
        const url = new URL(form.action);
        for (const [key, value] of new FormData(form)) if (String(value).trim()) url.searchParams.set(key, String(value).trim());
        if (view === 'catalog' && params.get('category')) url.searchParams.set('category', params.get('category'));
        url.hash = 'catalog-results';
        location.assign(url.href);
      });
    }
  }
  document.querySelectorAll('.finder').forEach(fillFinder);

  function renderCatalog() {
    const make = params.get('make') || '', model = params.get('model') || '', year = params.get('year') || '';
    const q = (params.get('q') || '').trim();
    const category = params.get('category') || '';
    const grid = document.querySelector('.collection');
    const sort = document.querySelector('#sort');
    if (['asc','desc'].includes(params.get('sort'))) sort.value = params.get('sort');
    for (const chip of document.querySelectorAll('[data-cat]')) {
      const current = chip.dataset.cat;
      const url = new URL(location.href);
      if (current) url.searchParams.set('category', current); else url.searchParams.delete('category');
      url.hash = 'catalog-results';
      chip.href = url.href;
      chip.setAttribute('aria-current', String(current === category));
    }
    const resultHeader = document.querySelector('.catalog-refine');
    resultHeader.id = 'catalog-results';
    function display() {
      const cards = Array.from(grid.children);
      const order = sort.value;
      cards.sort((a,b) => {
        const one = itemById.get(a.dataset.card), two = itemById.get(b.dataset.card);
        return order === 'asc' ? one.price-two.price : order === 'desc' ? two.price-one.price : parts.indexOf(one)-parts.indexOf(two);
      });
      let count = 0;
      const needle = compact(q);
      for (const card of cards) {
        const part = itemById.get(card.dataset.card);
        const keys = [part.number, ...part.aliases, part.name];
        const ok = (!category || category === part.category) && matches(part, make, model, year) &&
          (!q || Boolean(needle) && keys.some(key => compact(key).includes(needle)));
        card.hidden = !ok;
        if (ok) count++;
        grid.append(card);
        const detail = new URL(base + 'parts/' + part.slug + '/', document.baseURI);
        for (const key of ['make','model','year']) if (params.get(key)) detail.searchParams.set(key, params.get(key));
        card.querySelector('a').href = detail.href;
      }
      const qualifier = [make, models[model]?.name || model, year, q ? '“' + q + '”' : ''].filter(Boolean).join(' · ');
      document.querySelector('#results').textContent = count + (count === 1 ? ' part' : ' parts') + (qualifier ? ' for ' + qualifier : '');
      document.querySelector('#empty').hidden = count !== 0;
      grid.hidden = count === 0;
      document.querySelector('#reset').hidden = !(make || model || year || q || category || order !== 'featured');
    }
    sort.addEventListener('change', () => {
      const url = new URL(location.href);
      if (sort.value === 'featured') url.searchParams.delete('sort'); else url.searchParams.set('sort', sort.value);
      history.replaceState(null, '', url);
      display();
      for (const chip of document.querySelectorAll('[data-cat]')) {
        const next = new URL(chip.href);
        if (sort.value === 'featured') next.searchParams.delete('sort'); else next.searchParams.set('sort', sort.value);
        chip.href = next;
      }
    });
    display();
  }
  function showProduct() {
    const part = itemById.get(document.body.dataset.part);
    const {make, model, year} = Object.fromEntries(params);
    const matchBox = document.querySelector('[data-vehicle-match]');
    if ((model || make || year) && (!model || models[model])) {
      const label = [make || models[model]?.make, models[model]?.name, year].filter(Boolean).join(' ');
      matchBox.textContent = matches(part, make, model, year) ? 'Catalog match for ' + label + '. Check the configuration notes below.' : 'No listed match for ' + label + '. Confirm fitment with the retailer.';
      matchBox.hidden = false;
    }
    document.querySelector('[data-add]').addEventListener('click', () => {
      const list = readList();
      const oldCount = list[part.slug] || 0;
      list[part.slug] = Math.min(99, oldCount + 1);
      storeList(list); updateCount();
      const msg = document.querySelector('[data-feedback]');
      msg.replaceChildren(document.createTextNode(oldCount >= 99 ? 'Maximum quantity reached. ' : 'Added to your parts list. '));
      const link = document.createElement('a'); link.href = base + 'parts-list/'; link.textContent = 'View list'; msg.append(link);
    });
  }
  function renderList() {
    const list = readList(), container = document.querySelector('#list-items');
    container.replaceChildren();
    let total = 0;
    for (const [id, qty] of Object.entries(list)) {
      const p = itemById.get(id);
      total += Math.round(p.price*100)*qty;
      const row = document.createElement('article'); row.className = 'list-row';
      // Names, links and prices come from the published catalog, never from storage.
      row.innerHTML = '<img alt="" width="105" height="105"><div><h2><a></a></h2><p class="small"></p><a class="quiet" target="_blank" rel="noopener"></a></div><div class="qty"><button type="button" data-delta="-1">−</button><span></span><button type="button" data-delta="1">+</button></div><div class="list-actions"><strong></strong><button type="button" class="remove">Remove</button></div>';
      row.querySelector('img').src = base+'assets/'+id+'-small.webp';
      const link = row.querySelector('h2 a'); link.href = base+'parts/'+id+'/'; link.textContent = p.name;
      row.querySelector('.small').textContent = p.number+' · '+price(p.price)+' each';
      const retail = row.querySelector('.quiet'); retail.href=p.buy; retail.textContent='Buy at '+p.retailer;
      row.querySelector('.qty span').textContent=qty; row.querySelector('strong').textContent=price(p.price*qty);
      for (const button of row.querySelectorAll('[data-delta]')) {
        const delta=Number(button.dataset.delta);
        button.ariaLabel=(delta < 0 ? 'Decrease' : 'Increase')+' quantity of '+p.name;
        button.disabled=(delta<0 && qty<=1)||(delta>0 && qty>=99);
        button.addEventListener('click',()=>changeList(id,delta,false));
      }
      row.dataset.id=id;
      const remove=row.querySelector('.remove'); remove.ariaLabel='Remove '+p.name; remove.addEventListener('click',()=>changeList(id,0,true));
      container.append(row);
    }
    document.querySelector('#list-empty').hidden = total > 0;
    document.querySelector('#list-total').hidden = total === 0;
    document.querySelector('#total-value').textContent = price(total/100);
  }
  function changeList(id,delta,remove) {
    const list=readList();
    if(remove) delete list[id]; else list[id]=Math.min(99,Math.max(1,(list[id]||0)+delta));
    storeList(list); updateCount(); renderList();
    document.querySelector('#list-status').textContent=remove?'Part removed.':'Quantity updated to '+list[id]+'.';
    const row=document.querySelector('[data-id="'+id+'"]');
    const button=row?.querySelector('[data-delta="'+delta+'"]:not(:disabled)') || row?.querySelector('button:not(:disabled)') || document.querySelector('#list-items a, #list-empty a');
    button?.focus({preventScroll:true});
  }
  if (view==='catalog') renderCatalog();
  if (view==='product') showProduct();
  if (view==='list') renderList();
  updateCount();
  addEventListener('pageshow',()=>{ updateCount(); if(view==='list')renderList(); });
  addEventListener('storage',event=>{ if(event.key===listKey) { updateCount(); if(view==='list')renderList(); } });
})();
