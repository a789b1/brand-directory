const filters=[...document.querySelectorAll('[data-filter]')];
const cards=[...document.querySelectorAll('[data-platform]')];
const status=document.querySelector('#status');
function filterStores(platform){
 if(!['all','Shopify','WordPress'].includes(platform))platform='all';
 for(const button of filters){const active=button.dataset.filter===platform;button.classList.toggle('active',active);button.setAttribute('aria-pressed',String(active));}
 for(const card of cards)card.hidden=platform!=='all'&&card.dataset.platform!==platform;
 status.textContent=platform==='all'?'Showing all stores.':'Showing '+platform+' stores.';
}
for(const button of filters)button.addEventListener('click',()=>{filterStores(button.dataset.filter);history.replaceState(null,'',button.dataset.filter==='all'?location.pathname:'#'+button.dataset.filter.toLowerCase());});
filterStores(location.hash==='#shopify'?'Shopify':location.hash==='#wordpress'?'WordPress':'all');
addEventListener('hashchange',()=>filterStores(location.hash==='#shopify'?'Shopify':location.hash==='#wordpress'?'WordPress':'all'));
for(const button of document.querySelectorAll('[data-copy]'))button.addEventListener('click',async()=>{
 try{await navigator.clipboard.writeText(button.dataset.copy);button.textContent='Copied';status.textContent='Access code copied.';setTimeout(()=>button.textContent='Copy',2200);}
 catch{const code=button.previousElementSibling;const range=document.createRange();range.selectNodeContents(code);const selection=getSelection();selection.removeAllRanges();selection.addRange(range);status.textContent='Select and copy the access code shown.';}
});
