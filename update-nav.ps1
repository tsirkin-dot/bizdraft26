$dir = "c:\Users\oleksandrtsyrkin\Desktop\bizdraft-com-style\bizdraft2"
$pattern = '(?s)<div class="bz-navbar-type-1__links">.*?</div>'

$rootNav = @'
<div class="bz-navbar-type-1__links">
      <a class="bz-navbar-type-1__link" href="index.html">Home</a>
      <div class="bz-nav-dropdown">
        <a class="bz-navbar-type-1__link bz-nav-dropdown__trigger" href="agreement-templates.html">Templates</a>
        <div class="bz-nav-dropdown__panel">
          <p class="bz-nav-dropdown__group-title">Contracts</p>
          <a class="bz-nav-dropdown__link" href="agreement-templates/service-agreement.html">Service Agreement</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/independent-contractor.html">Independent Contractor</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/freelance-agreement.html">Freelance Contract</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/consulting-agreement.html">Consulting</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/statement-of-work.html">Scope of Work</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/master-service-agreement.html">Master Service Agreement</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/vendor-agreement.html">Vendor Agreement</a>
          <p class="bz-nav-dropdown__group-title">Employment</p>
          <a class="bz-nav-dropdown__link" href="agreement-templates/employment-agreement.html">Employment Contract</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/non-compete-agreement.html">Non-Compete</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/subcontractor-agreement.html">Subcontractor</a>
          <p class="bz-nav-dropdown__group-title">Business formation &amp; deals</p>
          <a class="bz-nav-dropdown__link" href="agreement-templates/nda.html">NDA</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/partnership-agreement.html">Partnership Agreement</a>
          <a class="bz-nav-dropdown__link" href="agreement-templates/llc-operating-agreement.html">LLC Operating</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=letter+of+intent">Letter of Intent</a>
          <a class="bz-nav-dropdown__footer" href="agreement-templates.html">See all agreement types &#x2192;</a>
        </div>
      </div>
      <div class="bz-nav-dropdown">
        <a class="bz-navbar-type-1__link bz-nav-dropdown__trigger" href="industries.html">Industries</a>
        <div class="bz-nav-dropdown__panel">
          <a class="bz-nav-dropdown__link" href="industries/construction-trades.html">Construction &amp; Trades</a>
          <a class="bz-nav-dropdown__link" href="industries/real-estate.html">Real Estate &amp; Property</a>
          <a class="bz-nav-dropdown__link" href="industries/saas-startups.html">Tech (IT / Software)</a>
          <a class="bz-nav-dropdown__link" href="industries/marketing-pr.html">Marketing &amp; Creative</a>
          <a class="bz-nav-dropdown__link" href="industries/photographers.html">Photography / Creative</a>
          <a class="bz-nav-dropdown__link" href="industries/professional-services.html">Professional Services</a>
          <a class="bz-nav-dropdown__link" href="industries/health-medical.html">Health &amp; Medical</a>
          <a class="bz-nav-dropdown__link" href="industries/retail-ecommerce.html">Retail &amp; E-commerce</a>
          <div class="bz-nav-dropdown__separator"></div>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=automotive+agreement">Automotive</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=logistics+delivery+agreement">Logistics &amp; Delivery</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=food+beverage+agreement">Food &amp; Beverage</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=hospitality+events+agreement">Hospitality &amp; Events</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=beauty+wellness+agreement">Beauty &amp; Wellness</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=pet+services+agreement">Pet Services</a>
          <a class="bz-nav-dropdown__link bz-nav-dropdown__link--editor" href="https://app.bizdraft.com/editor?prompt=education+care+agreement">Education &amp; Care</a>
        </div>
      </div>
      <a class="bz-navbar-type-1__link" href="for-business.html">For business</a>
      <a class="bz-navbar-type-1__link" href="how-it-works.html">How it works</a>
      <a class="bz-navbar-type-1__link" href="compare.html">Compare</a>
    </div>
'@

# Sub-page variant: prefix all local hrefs with ../
$subNav = $rootNav -replace 'href="(?!https?)([^"]+)"', 'href="../$1"'

$rootCount = 0
$subCount = 0

# Root-level HTML files
Get-ChildItem -Path $dir -Filter "*.html" -File | ForEach-Object {
    $path = $_.FullName
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    if ($content -match $pattern) {
        $newContent = [regex]::Replace($content, $pattern, $rootNav)
        [System.IO.File]::WriteAllText($path, $newContent, [System.Text.Encoding]::UTF8)
        $rootCount++
        Write-Host "ROOT: $($_.Name)"
    }
}

# Sub-directory HTML files
Get-ChildItem -Path $dir -Filter "*.html" -File -Recurse | Where-Object { $_.DirectoryName -ne $dir } | ForEach-Object {
    $path = $_.FullName
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    if ($content -match $pattern) {
        $newContent = [regex]::Replace($content, $pattern, $subNav)
        [System.IO.File]::WriteAllText($path, $newContent, [System.Text.Encoding]::UTF8)
        $subCount++
        Write-Host "SUB:  $($_.DirectoryName | Split-Path -Leaf)\$($_.Name)"
    }
}

Write-Host ""
Write-Host "Done. Root pages updated: $rootCount  Sub-pages updated: $subCount"
