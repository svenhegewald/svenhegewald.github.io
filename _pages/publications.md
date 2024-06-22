---
layout: page
permalink: /publications/
title: publications
description:
paper_years: [2024, 2023, 2022]
policy_years: [2018]
nav: true
nav_order: 2
---

<div class="publications">
<h2>peer-reviewed journal articles</h2>

{% for y in page.paper_years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

<div class="publications">
<h2>policy papers</h2>

{% for y in page.policy_years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f policypapers -q @*[year={{y}}]* %}
{% endfor %}

</div>
