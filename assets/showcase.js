document.querySelectorAll("[data-product]").forEach((product) => {
  product.addEventListener("change", (event) => {
    const option = event.target;
    if (!option.matches("input[data-price][data-sku]")) return;
    product.querySelector("[data-product-price]").textContent = option.dataset.price;
    product.querySelector("[data-sku]").textContent = option.dataset.sku;
  });
});

const specifications = document.getElementById("ProductSpecifications");
const specificationLink = document.querySelector('a[href="#ProductSpecifications"]');
if (specifications && specificationLink) {
  specificationLink.addEventListener("click", () => {
    specifications.open = true;
  });
}

const grid = document.querySelector("[data-grid]");
const sort = document.querySelector("[data-sort]");
if (grid && sort) {
  sort.closest("label").hidden = false;
  sort.addEventListener("change", () => {
    const items = [...grid.querySelectorAll("[data-card]")];
    const methods = {
      featured: (a, b) => Number(a.dataset.order) - Number(b.dataset.order),
      name: (a, b) => a.dataset.title.localeCompare(b.dataset.title, "en"),
      low: (a, b) => Number(a.dataset.price) - Number(b.dataset.price),
      high: (a, b) => Number(b.dataset.price) - Number(a.dataset.price),
    };
    grid.append(...items.sort(methods[sort.value]));
  });
}

const search = document.querySelector("[data-catalogue-search]");
if (grid && search) {
  const input = search.querySelector("input");
  const result = document.querySelector("[data-result-count]");
  const cards = [...grid.querySelectorAll("[data-card]")];
  function filter(query) {
    const words = query.toLowerCase().trim().split(/\s+/);
    let count = 0;
    for (const card of cards) {
      const searchable = card.dataset.search.toLowerCase();
      card.hidden = !words.every((word) => searchable.includes(word));
      if (!card.hidden) count += 1;
    }
    result.textContent = count === 1 ? "1 product found" : `${count} products found`;
  }
  search.hidden = false;
  input.value = new URL(location.href).searchParams.get("q") ?? "";
  filter(input.value);
  search.addEventListener("submit", (event) => {
    event.preventDefault();
    const url = new URL(location.href);
    const query = input.value.trim();
    if (query) url.searchParams.set("q", query);
    else url.searchParams.delete("q");
    history.replaceState(null, "", url);
    filter(query);
  });
}

const menu = document.querySelector("[data-mobile-nav]");
if (menu) {
  document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape" || !menu.open) return;
    menu.open = false;
    menu.querySelector("summary").focus();
  });
}
