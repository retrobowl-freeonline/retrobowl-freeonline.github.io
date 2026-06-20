# TXT mapping file
$mappingFile = "D:\a new data of single game\class\mapping.txt"

# Reverse mapping (ID → Game Name)
$idToGame = @{}

Get-Content $mappingFile | ForEach-Object {
    if ($_ -match "^(.*?)\s+([a-zA-Z0-9\-]+)$") {

        $gameSlug = $matches[1].Trim()
        $idCode   = $matches[2].Trim()

        $idToGame[$idCode] = $gameSlug
    }
}

Get-ChildItem -Directory | ForEach-Object {

    # Folder name = codex ID
    $folder = $_.Name

    # Skip if no mapping found
    if (-not $idToGame.ContainsKey($folder)) {
        Write-Host "Skipped: $folder (No mapping found)"
        return
    }

    # Get actual game slug from TXT
    $gameSlug = $idToGame[$folder]

    # Title generate from slug
    $title = $gameSlug -replace "-", " "
    $title = (Get-Culture).TextInfo.ToTitleCase($title)

    $index = Join-Path $_.FullName "index.html"

    if (!(Test-Path $index)) { return }

    $html = Get-Content $index -Raw

    if ($html -notmatch "<!-- Main-header-page -->") { return }

    Write-Host "Processing: $folder -> $gameSlug"

    $block = @"
<div id="ubgHeader" class="app-header desktop-nav-layout">
    <div class="header-left"><!--$--><button aria-label="Open/Close sidebar" class="sidebar-toggle-btn"> </button><a
        href="/">
        <div class="site-logo">
          <div class="logo-icon"><img src="/favicon.png" alt="Retro Bowl Unblocked" class="logo-image"
              style="width: 40px; height: 40px; margin-right: 10px;"><strong
              style="color: rgb(255, 255, 255); font-size: 24px;font-family:'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif">Retro Bowl</strong></div>
        </div>
      </a><!--/$--></div>
    <form class="search-form desktop-layout" autocomplete="off">
      <div class="search-input-wrapper"><input class="search-input search-field desktop-layout" id="search-input"
          placeholder="Search games and categories" type="text" autocomplete="off" autocorrect="off"
          autocapitalize="off" spellcheck="false" data-lpignore="true" data-form-type="other" data-1p-ignore="true"
          data-bwignore="true" data-form="false" aria-autocomplete="none">
        <div class="icon-box"><span role="img" aria-hidden="true" class="icon icon-search icon-size-20"></span>
        </div>
        <div id="search-suggestions" class="search-results-dropdown hidden"></div>
      </div>
    </form>
    <div class="header-right">
      <a href="/all-games/" aria-label="All Games"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop"><img
          src="/assest/icon/joystick-game-control-svgrepo-com.svg" alt="All Games"><span>All Games</span></a>
      <a href="/popular/" aria-label="Popular Games"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop"><img
          src="/assest/icon/category-svgrepo-com.svg" alt="Popular Games"><span>Popular Games</span></a>
      <a href="/setting/" aria-label="Setting"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop setting-icon"><img
          src="/assest/icon/settings-cog-line-svgrepo-com.svg" alt="Setting"></a>
    </div>
  </div>
  <div id="skrHeader" class="Header_mobile-43dhd mobile-nav-layout">
    <div class="Header_left-43dhd"><!--$--><a href="/">
        <div class="logo-43dhd">
          <div class="logo_icon-48dhd"><img src="/favicon.png" alt="Retro Bowl" class="logo_image-48dhd">
          </div>
        </div>
      </a><!--/$--></div>
    <div class="header-right">
      <a href="/all-games/" aria-label="All Games"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop btskr-icon"><img
          src="/assest/icon/joystick-game-control-svgrepo-com.svg" alt="All Games"></a>
      <a href="/popular/" aria-label="Popular Games"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop btskr-icon"><img
          src="/assest/icon/category-svgrepo-com.svg" alt="Popular Games"></a>
      <a href="/setting/" aria-label="Setting"
        class="btn btn-link-white btn-header-icon btn-header-icon-desktop setting-icon"><img
          src="/assest/icon/settings-cog-line-svgrepo-com.svg" alt="Setting"></a>
    </div>
  </div><br><br><br>
  <div id="root">
    <div id="search-results-page" class="search-results-page" aria-live="polite">
      <div class="search-results-header">
        <div>
          <h2 id="search-results-title" class="search-results-title"></h2>
          <p id="search-results-note" class="search-results-note"></p>
        </div>
        <button id="search-results-close" class="search-results-close" type="button"
          aria-label="Close search results">Close</button>
      </div>
      <div id="search-results-grid" class="search-results-grid"></div>
    </div>
    <div style="padding: 1rem 1rem 0px;">
      <div>
        <div class="n298 n411 n149 n397 n382">
          <div class="n282 n283 n262">
            <h1
              style="text-align:center;font-family:'Lato',sans-serif;font-weight:900;font-size:60px;color:#fff;position:relative;display:inline-block;left:50%;transform:translateX(-50%);margin-bottom:30px;">
              $title<span
                style="position:absolute;left:50%;transform:translateX(-50%);bottom:-12px;width:160px;height:7px;background:#ff7a00;display:block;border-radius:10px;"></span>
            </h1>
            <ul class="n159">
              <li class="n153 n158">
                <div class="n156" id="gameFrameWrapper">
                  <iframe data-testid="test_app_frame" id="test_app_frame" allowfullscreen=""
                    allow="autoplay; fullscreen; camera; focus-without-user-activation *; monetization; gamepad; keyboard-map *; xr-spatial-tracking; accelerometer; magnetometer; gyroscope; microphone *"
                    name="gameFrame" scrolling="no"
                    sandbox="allow-scripts allow-same-origin allow-forms allow-modals allow-orientation-lock allow-pointer-lock allow-presentation"
                    src="iframepaste-here" style="width: 100%; height: 100%; border: none;">
                  </iframe>
                </div>
                <div class="n152">
                  <div class="n160">
                    <div class="n161">
                      <img srcset="/assest/images/$folder-small@2x.webp 1x, /assest/images/$folder-small@2x.webp 2x"
                        alt="$title" title="$title">
                    </div>
                    <div class="n154">
                      <h2 class="n162">$title Unblocked</h2>
                    </div>
                  </div>
                  <div class="n151"><button class="n290" id="Share Game" title="share-game"><svg viewBox="0 0 24 24"
                        width="18" height="18" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path d="M4 12v7a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-7" stroke="#fff" stroke-width="1.5"
                          stroke-linecap="round" stroke-linejoin="round">
                        </path>
                        <path d="M16 6l-4-4-4 4" stroke="#fff" stroke-width="1.5" stroke-linecap="round"
                          stroke-linejoin="round"></path>
                        <path d="M12 2v14" stroke="#fff" stroke-width="1.5" stroke-linecap="round"
                          stroke-linejoin="round"></path>
                      </svg><span>Share</span></button><button class="n290" id="refresh-game" aria-label="Refresh game"
                      title="Refresh game"><svg viewBox="0 0 24 24" width="18" height="18" fill="none"
                        xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <path
                          d="M4.06189 13C4.02104 12.6724 4 12.3387 4 12C4 7.58172 7.58172 4 12 4C14.5006 4 16.7332 5.14727 18.2002 6.94416M19.9381 11C19.979 11.3276 20 11.6613 20 12C20 16.4183 16.4183 20 12 20C9.61061 20 7.46589 18.9525 6 17.2916M9 17H6V17.2916M18.2002 4V6.94416M18.2002 6.94416V6.99993L15.2002 7M6 20V17.2916"
                          stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
                      </svg><span>Refresh</span></button><button class="n290" id="jump-to-controls"
                      aria-label="Jump to controls" title="Jump to controls"><svg
                        class="MuiSvgIcon-root MuiSvgIcon-fontSizeMedium css-14yq2cq" focusable="false"
                        aria-hidden="true" viewBox="0 0 24 24" width="24" height="24">
                        <path fill-rule="evenodd" clip-rule="evenodd"
                          d="M14.2 2H9.8C8.14315 2 6.8 3.34314 6.8 5V6.8H5C3.34314 6.8 2 8.14315 2 9.8V14.2C2 15.8569 3.34314 17.2 5 17.2H6.8V19C6.8 20.6569 8.14315 22 9.8 22H14.2C15.8569 22 17.2 20.6569 17.2 19V17.2H19C20.6569 17.2 22 15.8569 22 14.2V9.8C22 8.14315 20.6569 6.8 19 6.8H17.2V5C17.2 3.34314 15.8569 2 14.2 2ZM15.2 5C15.2 4.44772 14.7523 4 14.2 4H9.8C9.24772 4 8.8 4.44771 8.8 5V7.8C8.8 8.35228 8.35229 8.8 7.8 8.8H5C4.44772 8.8 4 9.24772 4 9.8V14.2C4 14.7523 4.44771 15.2 5 15.2H7.8C8.35228 15.2 8.8 15.6477 8.8 16.2V19C8.8 19.5523 9.24772 20 9.8 20H14.2C14.7523 20 15.2 19.5523 15.2 19V16.2C15.2 15.6477 15.6477 15.2 16.2 15.2H19C19.5523 15.2 20 14.7523 20 14.2V9.8C20 9.24772 19.5523 8.8 19 8.8H16.2C15.6477 8.8 15.2 8.35229 15.2 7.8V5ZM10.6465 7.41422C10.4512 7.21896 10.4512 6.90238 10.6465 6.70712L11 6.35356C11.5858 5.76777 12.5356 5.76777 13.1213 6.35356L13.4749 6.70712C13.6702 6.90238 13.6702 7.21896 13.4749 7.41422C13.2796 7.60948 12.9631 7.60948 12.7678 7.41422L12.4142 7.06066C12.219 6.8654 11.9024 6.8654 11.7071 7.06066L11.3536 7.41422C11.1583 7.60948 10.8417 7.60948 10.6465 7.41422ZM7.47486 13.4748C7.2796 13.6701 6.96302 13.6701 6.76775 13.4748L6.41419 13.1213C5.82841 12.5355 5.82841 11.5857 6.41419 10.9999L6.76775 10.6464C6.96302 10.4511 7.2796 10.4511 7.47486 10.6464C7.67012 10.8416 7.67012 11.1582 7.47486 11.3535L7.1213 11.707C6.92604 11.9023 6.92604 12.2189 7.1213 12.4141L7.47486 12.7677C7.67012 12.963 7.67012 13.2796 7.47486 13.4748ZM13.4749 17.4142C13.6701 17.219 13.6701 16.9024 13.4749 16.7071C13.2796 16.5119 12.963 16.5119 12.7678 16.7071L12.4142 17.0607C12.2189 17.2559 11.9024 17.2559 11.7071 17.0607L11.3535 16.7071C11.1583 16.5119 10.8417 16.5119 10.6464 16.7071C10.4512 16.9024 10.4512 17.219 10.6464 17.4142L11 17.7678C11.5858 18.3536 12.5355 18.3536 13.1213 17.7678L13.4749 17.4142ZM16.7297 10.6409C16.928 10.4488 17.2446 10.4538 17.4367 10.6522L17.7846 11.0113C18.361 11.6064 18.3458 12.556 17.7508 13.1324L17.3916 13.4803C17.1933 13.6724 16.8768 13.6673 16.6846 13.469C16.4925 13.2706 16.4975 12.9541 16.6959 12.762L17.055 12.4141C17.2534 12.222 17.2584 11.9054 17.0663 11.7071L16.7184 11.3479C16.5263 11.1496 16.5313 10.833 16.7297 10.6409Z"
                          fill="#fff">
                        </path>
                      </svg><span>Controls</span></button>
                    <button class="n290" id="enter-fullscreen" aria-label="Enter fullscreen"
                      title="Enter fullscreen (F)"><svg fill="#fff" height="24px" width="24px" version="1.1"
                        id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                        viewBox="0 0 512 512" enable-background="new 0 0 512 512" xml:space="preserve">
                        <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                        <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                        <g id="SVGRepo_iconCarrier">
                          <path
                            d="M93.1,139.6l46.5-46.5L93.1,46.5L139.6,0H0v139.6l46.5-46.5L93.1,139.6z M93.1,372.4l-46.5,46.5L0,372.4V512h139.6 l-46.5-46.5l46.5-46.5L93.1,372.4z M372.4,139.6H139.6v232.7h232.7V139.6z M325.8,325.8H186.2V186.2h139.6V325.8z M372.4,0 l46.5,46.5l-46.5,46.5l46.5,46.5l46.5-46.5l46.5,46.5V0H372.4z M418.9,372.4l-46.5,46.5l46.5,46.5L372.4,512H512V372.4l-46.5,46.5 L418.9,372.4z">
                          </path>
                        </g>
                      </svg><span>Full screen</span></button>
                  </div>
                </div>
              </li>
              <li class="n131 ad-desktop-only">
                <div class="n126 n178 vertical">
                  <div class="n132"></div>
                  <span class="n129">Advertisement</span>
                </div>
              </li>
              <li class="n130">
                <div class="n126 vertical">
                  <div class="n132"></div>
                  <span class="n129">Advertisement</span>
                </div>
              </li>
              <li class="n127">
                <div class="n126 n171 horizontal">
                  <div class="n132"></div>
                  <span class="n129">Advertisement</span>
                </div>
              </li>
            </ul><br>
            <h2
              style="text-align:center;font-family:'Lato',sans-serif;font-weight:900;font-size:40px;color:#fff;position:relative;display:inline-block;left:50%;transform:translateX(-50%);margin-bottom:30px;">
              Related Games<span
                style="position:absolute;left:50%;transform:translateX(-50%);bottom:-12px;width:160px;height:5px;background:#ff7a00;display:block;border-radius:10px;"></span>
            </h2>
            <div id="random-games-target" class="rh48">
              <li class="n127">
                <div class="n126 n171 horizontal">
                  <div class="n132"></div>
                  <span class="n129">Advertisement</span>
                </div>
              </li>
"@

    $html = $html -replace [regex]::Escape("<!-- Main-header-page -->"), $block

    Set-Content $index $html -Encoding UTF8
}