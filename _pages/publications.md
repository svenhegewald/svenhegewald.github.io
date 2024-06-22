---
layout: page
permalink: /publications/
title: publications
description:
paper_years: [2024, 2023, 2022]
nav: true
nav_order: 2
---

<!-- _pages/publications.md -->
<div class="publications">
<h2>peer-reviewed journal articles</h2>
{% for y in page.paper_years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
