(function bootstrapLandingPage() {
  'use strict';

  const contentService = {
    getSite: function getSite() {
      return window.CONTENT && window.CONTENT.site ? window.CONTENT.site : {};
    },
    getHero: function getHero() {
      return window.CONTENT && window.CONTENT.hero ? window.CONTENT.hero : {};
    },
    getTrustSignals: function getTrustSignals() {
      return window.CONTENT && Array.isArray(window.CONTENT.trustSignals)
        ? window.CONTENT.trustSignals
        : [];
    },
    getTrustTimeline: function getTrustTimeline() {
      return window.CONTENT && Array.isArray(window.CONTENT.trustTimeline)
        ? window.CONTENT.trustTimeline
        : [];
    },
    getServices: function getServices() {
      return window.CONTENT && window.CONTENT.services ? window.CONTENT.services : {};
    },
    getCatalogItems: function getCatalogItems() {
      return window.CONTENT && Array.isArray(window.CONTENT.catalogItems)
        ? window.CONTENT.catalogItems
        : [];
    },
    getProcess: function getProcess() {
      return window.CONTENT && window.CONTENT.processSteps
        ? window.CONTENT.processSteps
        : {};
    },
    getTestimonials: function getTestimonials() {
      return window.CONTENT && window.CONTENT.testimonials
        ? window.CONTENT.testimonials
        : {};
    },
    getAbout: function getAbout() {
      return window.CONTENT && window.CONTENT.about ? window.CONTENT.about : {};
    },
    getContact: function getContact() {
      return window.CONTENT && window.CONTENT.contact ? window.CONTENT.contact : {};
    },
    getFaq: function getFaq() {
      return window.CONTENT && window.CONTENT.faq ? window.CONTENT.faq : {};
    },
    getVideo: function getVideo() {
      return window.CONTENT && window.CONTENT.video ? window.CONTENT.video : {};
    },
    getMobileCta: function getMobileCta() {
      return window.CONTENT && window.CONTENT.mobileCta ? window.CONTENT.mobileCta : {};
    },
    getTone: function getTone() {
      return window.CONTENT && window.CONTENT.tone ? window.CONTENT.tone : {};
    }
  };

  var isDevEnvironment =
    window.location.hostname === 'localhost' ||
    window.location.hostname === '127.0.0.1' ||
    window.location.protocol === 'file:';

  function escapeHtml(value) {
    if (typeof value !== 'string') return '';
    return value
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function getBilingualText(input, path) {
    if (typeof input === 'string') return { fr: input, mg: input };
    var fr = input && typeof input.fr === 'string' ? input.fr : '';
    var mg = input && typeof input.mg === 'string' ? input.mg : '';
    var fallback = fr || mg || '';
    if (!mg && isDevEnvironment) {
      console.error('[BILINGUAL_FALLBACK] mg manquant pour:', path);
    }
    return { fr: fr || fallback, mg: mg || fallback };
  }

  function bilingualHtml(input, path, options) {
    var resolved = getBilingualText(input, path);
    var frClass = options && options.frClass ? options.frClass : '';
    var mgClass = options && options.mgClass ? options.mgClass : '';
    return (
      '<span lang="fr" class="' + frClass + '">' + escapeHtml(resolved.fr) + '</span>' +
      '<span lang="mg" class="' + mgClass + '">' + escapeHtml(resolved.mg) + '</span>'
    );
  }

  function getElement(id) {
    return document.getElementById(id);
  }

  function normalizePhoneNumber(value) {
    if (typeof value !== 'string') return '';
    return value.replace(/[^\d]/g, '');
  }

  function hasWhatsappConfigured() {
    var site = contentService.getSite();
    return normalizePhoneNumber(site.whatsappNumber).length > 0;
  }

  function buildWhatsappUrl(messageInput) {
    var site = contentService.getSite();
    var phoneNumber = normalizePhoneNumber(site.whatsappNumber);
    if (!phoneNumber) return '';
    var defaultMessage = getBilingualText(site.defaultWhatsappMessage, 'site.defaultWhatsappMessage').fr;
    var messageText =
      typeof messageInput === 'string' && messageInput.trim().length > 0
        ? messageInput
        : defaultMessage;
    return 'https://wa.me/' + phoneNumber + '?text=' + encodeURIComponent(messageText);
  }

  function trackEvent(eventName, payload) {
    if (!eventName) return;
    if (window.dataLayer && Array.isArray(window.dataLayer)) {
      window.dataLayer.push(Object.assign({ event: eventName }, payload || {}));
    }
  }

  // ─── NAVIGATION ──────────────────────────────────────────
  function renderNavigation() {
    var site = contentService.getSite();
    var navRoot = getElement('main-nav');
    var mobileNav = getElement('mobile-nav');
    if (!Array.isArray(site.nav)) return;

    var navHtml = site.nav
      .map(function(link) {
        var href = link && link.href ? link.href : '#home';
        var label = getBilingualText(link.label, 'nav').fr;
        return '<li><a href="' + escapeHtml(href) + '" class="nav-link">' + escapeHtml(label) + '</a></li>';
      })
      .join('');

    if (navRoot) navRoot.innerHTML = navHtml;
    if (mobileNav) mobileNav.innerHTML = navHtml;
  }

  // ─── HERO ────────────────────────────────────────────────
  function renderHero() {
    var hero = contentService.getHero();
    var site = contentService.getSite();
    var heroContent = getElement('hero-content');
    var heroVisual = getElement('hero-visual');
    if (!heroContent || !heroVisual) return;

    var isWhatsappEnabled = hasWhatsappConfigured();
    var primaryMessage = getBilingualText(site.defaultWhatsappMessage, 'site.defaultWhatsappMessage').fr;

    var primaryCta = isWhatsappEnabled
      ? '<a href="' + escapeHtml(buildWhatsappUrl(primaryMessage)) + '" class="cta-primary" data-track-cta="hero_primary">' +
        '<span class="text-sm">' + escapeHtml(getBilingualText(hero.ctaPrimary, 'hero.ctaPrimary').fr) + '</span></a>'
      : '<a href="#order" class="cta-primary" data-track-cta="hero_primary_fallback">' +
        '<span class="text-sm">' + escapeHtml(getBilingualText(hero.ctaSecondary, 'hero.ctaSecondary').fr) + '</span></a>';

    var secondaryCta =
      '<a href="#order" class="cta-secondary" data-track-cta="hero_secondary">' +
      '<span class="text-sm">' + escapeHtml(getBilingualText(hero.ctaSecondary, 'hero.ctaSecondary').fr) + '</span></a>';

    heroContent.className = 'relative z-10 hero-stagger flex flex-col justify-center';

    heroContent.innerHTML =
      '<p class="text-sm font-semibold text-primary/80 uppercase tracking-widest">' +
      escapeHtml(getBilingualText(hero.badge, 'hero.badge').fr) +
      '</p>' +
      '<h1 id="hero-title" class="mt-4 text-3xl sm:text-4xl md:text-5xl font-extrabold leading-tight text-primary">' +
      '<span class="text-primary">' + escapeHtml(getBilingualText(hero.title, 'hero.title').fr) + '</span>' +
      '</h1>' +
      '<p class="mt-2 text-sm text-primary/60">' +
      escapeHtml(getBilingualText(hero.title, 'hero.title').mg) +
      '</p>' +
      '<p class="mt-5 max-w-[52ch] text-base leading-relaxed text-ink/75">' +
      escapeHtml(getBilingualText(hero.subtitle, 'hero.subtitle').fr) +
      '</p>' +
      '<p class="mt-2 text-sm text-ink/50">' +
      escapeHtml(getBilingualText(hero.subtitle, 'hero.subtitle').mg) +
      '</p>' +
      '<div class="mt-8 flex flex-wrap gap-3">' +
      primaryCta +
      secondaryCta +
      '</div>' +
      '<p class="mt-5 text-xs uppercase tracking-[0.12em] font-semibold text-primary/60">PROOF FIRST · SERVICE HUMAIN</p>';

    // Hero visual: image + trust badges
    var microProofs = Array.isArray(hero.microProofs) ? hero.microProofs : [];

    heroVisual.innerHTML =
      '<div class="relative">' +
      '<div class="relative mx-auto max-w-sm lg:max-w-md">' +
      '<img src="' + escapeHtml(hero.image || './assets/hero-F.R.I.D.A.Y.svg') +
      '" alt="F.R.I.D.A.Y personal shopper" class="w-full h-auto rounded-2xl shadow-lg object-cover" fetchpriority="high" />' +
      '</div>' +
      // Trust badges floating on right
      '<div class="mt-4 lg:absolute lg:right-0 lg:top-1/4 lg:mt-0 flex flex-col gap-3 lg:translate-x-4">' +
      '<div class="trust-badge">' +
      '<div class="trust-badge-icon">🏢</div>' +
      '<div>' +
      '<p class="text-sm font-bold text-ink">' + escapeHtml(microProofs[0] || 'Bureau réel à Betongolo') + '</p>' +
      '<p class="text-xs text-ink-soft mt-0.5">' + escapeHtml(microProofs[1] || 'Achat validé avant paiement final') + '</p>' +
      '<p class="text-xs text-ink-soft">' + escapeHtml(microProofs[2] || 'Suivi régulier jusqu\'à réception') + '</p>' +
      '</div>' +
      '</div>' +
      '<div class="trust-badge">' +
      '<div class="trust-badge-icon">🔒</div>' +
      '<div>' +
      '<p class="text-sm font-bold text-ink">Confiance construite étape par étape</p>' +
      '<p class="text-xs text-ink-soft mt-0.5">Aucune zone floue: preuves sociales et cadre légal en continu.</p>' +
      '</div>' +
      '</div>' +
      '</div>' +
      '</div>';
  }

  // (Trust area removed – integrated into hero visual)
  function renderTrustArea() {}

  // ─── SERVICES ────────────────────────────────────────────
  function renderServices() {
    var data = contentService.getServices();
    var title = getElement('services-title');
    var subtitle = getElement('services-subtitle');
    var grid = getElement('services-grid');
    if (!title || !subtitle || !grid) return;

    title.innerHTML = bilingualHtml(data.title, 'services.title', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm text-ink-soft'
    });
    subtitle.innerHTML = bilingualHtml(data.subtitle, 'services.subtitle', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm'
    });

    // Map services to product images
    var serviceImages = [
      './assets/product-bag.svg',
      './assets/product-beauty.svg',
      './assets/product-tech.svg',
      './assets/product-baby.svg',
      './assets/product-shoes.svg'
    ];

    var items = Array.isArray(data.items) ? data.items : [];
    grid.innerHTML = items
      .map(function(item, index) {
        return (
          '<article class="card-surface service-card" data-reveal>' +
          '<img src="' + escapeHtml(serviceImages[index] || './assets/product-default.svg') +
          '" alt="" class="service-card-img" loading="lazy" />' +
          '<div class="min-w-0">' +
          '<h3 class="font-bold text-ink text-sm">' +
          bilingualHtml(item.name, 'services.items[' + index + '].name', {
            frClass: 'block',
            mgClass: 'block text-xs text-ink-soft mt-0.5'
          }) +
          '</h3>' +
          '<p class="mt-1.5 text-xs text-ink-soft leading-relaxed">' +
          bilingualHtml(item.detail, 'services.items[' + index + '].detail', {
            frClass: 'block',
            mgClass: 'block mt-0.5 text-[0.68rem]'
          }) +
          '</p>' +
          '</div>' +
          '</article>'
        );
      })
      .join('');
  }

  // ─── CATALOG ─────────────────────────────────────────────
  function buildProductWhatsappMessage(item) {
    var itemName = getBilingualText(item.name, 'catalogItems.name').fr;
    var itemPrice = getBilingualText(item.price, 'catalogItems.price').fr;
    return 'Bonjour, je souhaite commander: ' + itemName + ' (' + itemPrice + ').';
  }

  function renderCatalog() {
    var title = getElement('catalogue-title');
    var subtitle = getElement('catalogue-subtitle');
    var grid = getElement('catalog-grid');
    var items = contentService.getCatalogItems();
    var isWhatsappEnabled = hasWhatsappConfigured();
    if (!title || !subtitle || !grid) return;

    title.innerHTML =
      '<span lang="fr" class="block">Sélection du moment</span>' +
      '<span lang="mg" class="block mt-1 text-sm text-ink-soft">Safidy malaza amin\'izao</span>';

    subtitle.innerHTML =
      '<span lang="fr" class="block">Des références concrètes pour décider vite.</span>' +
      '<span lang="mg" class="block mt-1 text-sm">Modely mazava hanampy anao hanapa-kevitra haingana.</span>';

    grid.innerHTML = items
      .map(function(item, index) {
        var cta = isWhatsappEnabled
          ? '<a href="' + escapeHtml(buildWhatsappUrl(buildProductWhatsappMessage(item))) +
            '" class="cta-primary mt-4 w-full text-sm" data-track-cta="catalog_' + escapeHtml(item.id || String(index + 1)) +
            '">Commander ce produit</a>'
          : '<a href="#order" class="cta-outline mt-4 w-full text-sm" data-track-cta="catalog_form_' +
            escapeHtml(item.id || String(index + 1)) + '">Passer par formulaire</a>';

        return (
          '<article class="card-surface flex flex-col group" data-reveal>' +
          '<div class="overflow-hidden rounded-lg -mx-1.5 -mt-1.5 mb-1">' +
          '<img src="' + escapeHtml(item.image || './assets/product-default.svg') +
          '" alt="' + escapeHtml(getBilingualText(item.name, 'catalogItems[' + index + '].name').fr) +
          '" loading="lazy" class="h-48 w-full object-cover transition-transform duration-500 group-hover:scale-105" />' +
          '</div>' +
          '<p class="mt-3 text-xs font-semibold uppercase tracking-wide text-primary/60">' +
          escapeHtml(getBilingualText(item.category, 'catalogItems[' + index + '].category').fr) +
          '</p>' +
          '<h3 class="mt-1.5 font-bold text-ink">' +
          escapeHtml(getBilingualText(item.name, 'catalogItems[' + index + '].name').fr) +
          '</h3>' +
          '<p class="mt-1.5 text-sm font-semibold text-accent">' +
          escapeHtml(getBilingualText(item.price, 'catalogItems[' + index + '].price').fr) +
          '</p>' +
          '<p class="mt-1 text-xs text-ink-soft">Livraison: ' +
          escapeHtml(getBilingualText(item.delivery, 'catalogItems[' + index + '].delivery').fr) +
          '</p>' +
          cta +
          '</article>'
        );
      })
      .join('');
  }

  // ─── PROCESS ─────────────────────────────────────────────
  function renderProcess() {
    var process = contentService.getProcess();
    var title = getElement('process-title');
    var subtitle = getElement('process-subtitle');
    var list = getElement('process-list');
    var visual = getElement('process-list-visual');
    if (!title || !subtitle || !list) return;

    title.innerHTML = bilingualHtml(process.title, 'processSteps.title', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm text-ink-soft'
    });
    subtitle.innerHTML = bilingualHtml(process.subtitle, 'processSteps.subtitle', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm'
    });

    var items = Array.isArray(process.items) ? process.items : [];

    // Visual numbered flow (desktop only)
    if (visual) {
      var visualHtml = '<div class="process-visual">';
      items.forEach(function(step, index) {
        var frTitle = getBilingualText(step.title, 'processSteps.items[' + index + '].title').fr;
        var shortTitle = frTitle.replace(/^\d+\.\s*/, '');
        visualHtml +=
          '<div class="process-visual-step">' +
          '<div class="process-step-number">' + String(index + 1) + '</div>' +
          '<span class="text-sm font-semibold text-ink">' + escapeHtml(shortTitle) + '</span>' +
          '</div>';
        if (index < items.length - 1) {
          visualHtml += '<div class="process-visual-connector"></div>';
        }
      });
      visualHtml += '</div>';
      visual.innerHTML = visualHtml;
    }

    // Detail cards
    list.innerHTML = items
      .map(function(step, index) {
        return (
          '<li class="card-surface text-center" data-reveal>' +
          '<div class="process-step-number mx-auto mb-3">' + String(index + 1) + '</div>' +
          '<h3 class="font-bold text-ink text-sm">' +
          bilingualHtml(step.title, 'processSteps.items[' + index + '].title', {
            frClass: 'block',
            mgClass: 'block text-xs text-ink-soft mt-0.5'
          }) +
          '</h3>' +
          '<p class="mt-2 text-xs text-ink-soft">' +
          bilingualHtml(step.detail, 'processSteps.items[' + index + '].detail', {
            frClass: 'block',
            mgClass: 'block text-[0.68rem] mt-0.5'
          }) +
          '</p>' +
          '</li>'
        );
      })
      .join('');
  }

  // ─── TESTIMONIALS ────────────────────────────────────────
  function renderTestimonials() {
    var data = contentService.getTestimonials();
    var title = getElement('testimonials-title');
    var subtitle = getElement('testimonials-subtitle');
    var grid = getElement('testimonials-grid');
    if (!title || !subtitle || !grid) return;

    title.innerHTML = bilingualHtml(data.title, 'testimonials.title', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm text-ink-soft'
    });
    subtitle.innerHTML = bilingualHtml(data.subtitle, 'testimonials.subtitle', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm'
    });

    var items = Array.isArray(data.items) ? data.items : [];
    grid.innerHTML = items
      .map(function(item, index) {
        var initial = (item.author || 'C').charAt(0);
        var sourceColors = {
          'Facebook': 'bg-blue-500',
          'Instagram': 'bg-pink-500',
          'TikTok': 'bg-gray-800'
        };
        var avatarBg = sourceColors[item.source] || 'bg-primary';
        return (
          '<article class="card-surface testimonial-card" data-reveal>' +
          '<div class="flex items-center gap-3 mb-4">' +
          '<div class="flex h-11 w-11 items-center justify-center rounded-full ' + avatarBg + ' text-white font-bold text-sm">' +
          escapeHtml(initial) +
          '</div>' +
          '<div>' +
          '<p class="font-bold text-ink">' + escapeHtml(item.author || 'Client') + '</p>' +
          '<p class="text-xs text-ink-soft">' + escapeHtml(item.source || 'Social') + '</p>' +
          '</div>' +
          '</div>' +
          '<p class="text-sm leading-relaxed text-ink/80">' +
          bilingualHtml(item.quote, 'testimonials.items[' + index + '].quote', {
            frClass: 'block',
            mgClass: 'block text-xs mt-1.5 text-ink-soft'
          }) +
          '</p>' +
          '</article>'
        );
      })
      .join('');
  }

  // ─── CTA BANNER ──────────────────────────────────────────
  function renderCtaBanner() {
    var banner = getElement('cta-banner-content');
    var contact = contentService.getContact();
    var isWhatsappEnabled = hasWhatsappConfigured();
    if (!banner) return;

    var whatsappBtn = isWhatsappEnabled
      ? '<a href="' + escapeHtml(buildWhatsappUrl()) + '" class="cta-whatsapp" data-track-cta="banner_whatsapp">' +
        '💬 ' + escapeHtml(getBilingualText(contact.whatsappLabel, 'contact.whatsappLabel').fr) + '</a>'
      : '<a href="#order" class="cta-whatsapp" data-track-cta="banner_form">Remplir le formulaire</a>';

    banner.innerHTML =
      '<div class="flex items-center gap-3">' +
      '<span class="text-2xl">➕</span>' +
      '<div>' +
      '<p class="text-white font-bold text-lg">Commander ce produit 1inh, vhelymy mppangifa azo hamirlina</p>' +
      '<p class="text-white/70 text-sm mt-1">Vorrera tearne ny haoñmmaŋ. Ees trahòle amówaáš – madendre ne samplodes.</p>' +
      '</div>' +
      '</div>' +
      whatsappBtn;
  }

  // ─── ABOUT + VIDEO ───────────────────────────────────────
  function renderAbout() {
    var about = contentService.getAbout();
    var site = contentService.getSite();
    var main = getElement('about-main');
    var videoBlock = getElement('about-video');
    if (!main) return;

    var highlights = Array.isArray(about.highlights) ? about.highlights : [];

    main.innerHTML =
      '<h2 id="about-title" class="text-xl font-extrabold text-ink">' +
      bilingualHtml(about.title, 'about.title', {
        frClass: 'block',
        mgClass: 'block mt-1 text-sm text-ink-soft'
      }) +
      '</h2>' +
      '<p class="mt-3 text-sm text-ink-soft leading-relaxed">' +
      bilingualHtml(about.summary, 'about.summary', {
        frClass: 'block',
        mgClass: 'block mt-2 text-xs'
      }) +
      '</p>' +
      '<ul class="mt-4 space-y-2">' +
      highlights
        .map(function(item, index) {
          return (
            '<li class="flex items-start gap-2 text-sm text-ink/80">' +
            '<span class="text-primary mt-0.5">✓</span>' +
            '<span>' + bilingualHtml(item, 'about.highlights[' + index + ']', {
              frClass: 'block',
              mgClass: 'block mt-0.5 text-xs text-ink-soft'
            }) + '</span>' +
            '</li>'
          );
        })
        .join('') +
      '</ul>';

    // Video block
    if (videoBlock) {
      var video = contentService.getVideo();
      var isWhatsappEnabled = hasWhatsappConfigured();
      var whatsappCta = isWhatsappEnabled
        ? '<a href="' + escapeHtml(buildWhatsappUrl()) + '" class="cta-whatsapp mt-4 w-full" data-track-cta="about_whatsapp">' +
          '💬 ' + escapeHtml(getBilingualText(contentService.getContact().whatsappLabel, 'contact.whatsappLabel').fr) + '</a>'
        : '';

      videoBlock.innerHTML =
        '<div class="flex flex-col h-full">' +
        '<p class="text-sm font-semibold text-ink-soft mb-3">' +
        escapeHtml(getBilingualText(video.title, 'video.title').mg) +
        '</p>' +
        '<a href="' + escapeHtml(video.externalUrl || '#') + '" target="_blank" rel="noopener noreferrer" class="block relative rounded-xl overflow-hidden group">' +
        '<img src="' + escapeHtml(video.thumbnail || './assets/video-thumb.svg') +
        '" alt="Vidéo" loading="lazy" class="w-full h-48 object-cover transition-transform duration-500 group-hover:scale-105" />' +
        '<div class="absolute inset-0 bg-black/30 flex items-center justify-center">' +
        '<div class="w-14 h-14 rounded-full bg-white/90 flex items-center justify-center shadow-lg">' +
        '<span class="text-primary text-2xl ml-1">▶</span>' +
        '</div>' +
        '</div>' +
        '</a>' +
        '<p class="mt-3 text-xs text-ink-soft">' +
        escapeHtml(getBilingualText(video.description, 'video.description').fr) +
        '</p>' +
        whatsappCta +
        '</div>';
    }
  }

  function renderVideo() {}

  // ─── ORDER ───────────────────────────────────────────────
  function renderOrderHeader() {
    var title = getElement('order-title');
    var subtitle = getElement('order-subtitle');
    var contact = contentService.getContact();
    if (!title || !subtitle) return;

    title.innerHTML = bilingualHtml(contact.title, 'contact.title', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm text-ink-soft'
    });
    subtitle.innerHTML = bilingualHtml(contact.subtitle, 'contact.subtitle', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm'
    });
  }

  function renderOrderContactCard() {
    var card = getElement('order-contact-card');
    var site = contentService.getSite();
    var contact = contentService.getContact();
    var isWhatsappEnabled = hasWhatsappConfigured();
    if (!card) return;

    var whatsappCta = isWhatsappEnabled
      ? '<a href="' + escapeHtml(buildWhatsappUrl()) + '" class="cta-whatsapp w-full" data-track-cta="order_whatsapp">' +
        '💬 ' + bilingualHtml(contact.whatsappLabel, 'contact.whatsappLabel', {
          frClass: 'text-sm',
          mgClass: 'ml-2 text-xs'
        }) + '</a>'
      : '<p class="rounded border border-accent/40 bg-accent/5 px-3 py-2 text-sm text-accent">' +
        bilingualHtml(contact.fallbackText, 'contact.fallbackText', {
          frClass: 'block font-semibold',
          mgClass: 'block mt-1 text-xs'
        }) + '</p>';

    var socialLinks = Array.isArray(site.socials) ? site.socials : [];
    var socialsMarkup = socialLinks
      .map(function(social) {
        return '<a href="' + escapeHtml(social.url || '#') +
          '" target="_blank" rel="noopener noreferrer" class="social-chip">' +
          escapeHtml(social.name || 'Social') + '</a>';
      })
      .join('');

    card.innerHTML =
      '<h3 class="text-lg font-bold text-ink">Canal prioritaire: WhatsApp</h3>' +
      '<p class="mt-2 text-sm text-ink-soft">' +
      bilingualHtml(contact.subtitle, 'contact.subtitle', {
        frClass: 'block',
        mgClass: 'block mt-1 text-xs'
      }) + '</p>' +
      '<div class="mt-4">' + whatsappCta + '</div>' +
      '<div class="mt-4 rounded-lg border border-safe/30 bg-safe/5 px-3 py-2.5 text-sm text-ink/80">' +
      '<p class="font-semibold text-ink">Tarification transparente</p>' +
      '<p class="mt-1 text-ink-soft text-xs">Prix produit + frais + délai validés avant lancement.</p>' +
      '</div>' +
      '<div class="mt-4 flex flex-wrap gap-2">' + socialsMarkup + '</div>';
  }

  // ─── FAQ ─────────────────────────────────────────────────
  function renderFaq() {
    var faq = contentService.getFaq();
    var title = getElement('faq-title');
    var subtitle = getElement('faq-subtitle');
    var list = getElement('faq-list');
    if (!title || !subtitle || !list) return;

    title.innerHTML = bilingualHtml(faq.title, 'faq.title', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm text-ink-soft'
    });
    subtitle.innerHTML = bilingualHtml(faq.subtitle, 'faq.subtitle', {
      frClass: 'block',
      mgClass: 'block mt-1 text-sm'
    });

    var items = Array.isArray(faq.items) ? faq.items : [];
    list.innerHTML = items
      .map(function(item, index) {
        var buttonId = 'faq-button-' + String(index + 1);
        var panelId = 'faq-panel-' + String(index + 1);
        return (
          '<article data-reveal>' +
          '<button type="button" id="' + buttonId + '" class="faq-button" aria-expanded="false" aria-controls="' + panelId + '">' +
          '<span class="text-sm">' +
          bilingualHtml(item.question, 'faq.items[' + index + '].question', {
            frClass: 'block',
            mgClass: 'block mt-1 text-xs text-ink-soft'
          }) +
          '</span>' +
          '<span aria-hidden="true" class="text-lg font-bold text-primary">+</span>' +
          '</button>' +
          '<div id="' + panelId + '" class="faq-panel" role="region" aria-labelledby="' + buttonId + '" hidden>' +
          bilingualHtml(item.answer, 'faq.items[' + index + '].answer', {
            frClass: 'block text-sm',
            mgClass: 'block mt-1 text-xs'
          }) +
          '</div>' +
          '</article>'
        );
      })
      .join('');
  }

  function setupFaqAccordion() {
    var buttons = document.querySelectorAll('.faq-button');

    function closeAll() {
      buttons.forEach(function(button) {
        var panelId = button.getAttribute('aria-controls');
        var panel = panelId ? document.getElementById(panelId) : null;
        button.setAttribute('aria-expanded', 'false');
        var indicator = button.querySelector('span[aria-hidden="true"]');
        if (indicator) indicator.textContent = '+';
        if (panel) panel.hidden = true;
      });
    }

    buttons.forEach(function(button, index) {
      button.addEventListener('click', function() {
        var isExpanded = button.getAttribute('aria-expanded') === 'true';
        closeAll();
        if (!isExpanded) {
          var panelId = button.getAttribute('aria-controls');
          var panel = panelId ? document.getElementById(panelId) : null;
          button.setAttribute('aria-expanded', 'true');
          var indicator = button.querySelector('span[aria-hidden="true"]');
          if (indicator) indicator.textContent = '−';
          if (panel) panel.hidden = false;
        }
      });

      button.addEventListener('keydown', function(event) {
        if (event.key === 'ArrowDown') {
          event.preventDefault();
          buttons[(index + 1) % buttons.length].focus();
        }
        if (event.key === 'ArrowUp') {
          event.preventDefault();
          buttons[(index - 1 + buttons.length) % buttons.length].focus();
        }
      });
    });
  }

  // ─── FOOTER ──────────────────────────────────────────────
  function renderFooter() {
    var site = contentService.getSite();
    var tagline = getElement('footer-tagline');
    var links = getElement('footer-links');
    var legal = getElement('footer-legal');
    var copy = getElement('footer-copy');
    var office = getElement('footer-office');

    if (tagline) {
      tagline.innerHTML = bilingualHtml(site.tagline, 'site.tagline', {
        frClass: 'block',
        mgClass: 'block mt-1 text-xs opacity-70'
      });
    }

    var quickLinks = Array.isArray(site.quickLinks) ? site.quickLinks : [];
    if (links) {
      links.innerHTML = quickLinks
        .map(function(link, index) {
          return '<li><a href="' + escapeHtml(link.href || '#') +
            '" class="hover:text-white transition">' +
            escapeHtml(getBilingualText(link.label, 'site.quickLinks[' + index + '].label').fr) +
            '</a></li>';
        })
        .join('');
    }

    if (legal) {
      legal.innerHTML =
        '<li>' + escapeHtml(site.legal && site.legal.nif ? site.legal.nif : '') + '</li>' +
        '<li>' + escapeHtml(site.legal && site.legal.stat ? site.legal.stat : '') + '</li>';
    }

    if (office) {
      office.innerHTML = bilingualHtml(
        site.legal && site.legal.office ? site.legal.office : { fr: '', mg: '' },
        'site.legal.office',
        { frClass: 'block', mgClass: 'block mt-1 text-xs opacity-70' }
      );
    }

    if (copy) {
      copy.textContent = '© ' + String(new Date().getFullYear()) + ' ' +
        (site.brand || 'Personal Shopper France → Madagascar') + '. Tous droits réservés.';
    }
  }

  // ─── MOBILE CTA BAR ─────────────────────────────────────
  function renderMobileCtaBar() {
    var mobileBar = getElement('mobile-cta-bar');
    var mobileCta = contentService.getMobileCta();
    var isWhatsappEnabled = hasWhatsappConfigured();
    if (!mobileBar) return;

    var whatsappButton = isWhatsappEnabled
      ? '<a href="' + escapeHtml(buildWhatsappUrl()) +
        '" class="cta-primary text-center" data-track-cta="mobile_whatsapp">' +
        '<span class="text-xs">' + escapeHtml(getBilingualText(mobileCta.primaryLabel, 'mobileCta.primaryLabel').fr) + '</span></a>'
      : '<a href="#order" class="cta-outline text-center" data-track-cta="mobile_form_fallback">' +
        '<span class="text-xs">Commander</span></a>';

    var formButton =
      '<a href="#order" class="cta-outline text-center" data-track-cta="mobile_form">' +
      '<span class="text-xs">' + escapeHtml(getBilingualText(mobileCta.secondaryLabel, 'mobileCta.secondaryLabel').fr) + '</span></a>';

    var trustMessage =
      '<p class="mobile-cta-message">' +
      escapeHtml(getBilingualText(mobileCta.trustStatus, 'mobileCta.trustStatus').fr) +
      '</p>';

    mobileBar.innerHTML = whatsappButton + formButton + trustMessage;
  }

  // ─── FORM ────────────────────────────────────────────────
  function showFormFeedback(type, message) {
    var feedback = getElement('form-feedback');
    if (!feedback) return;
    feedback.classList.remove('hidden');
    if (type === 'success') {
      feedback.className = 'rounded border border-safe/40 bg-safe/5 px-3 py-2 text-sm text-ink';
    } else {
      feedback.className = 'rounded border border-accent/40 bg-accent/5 px-3 py-2 text-sm text-accent';
    }
    feedback.textContent = message;
  }

  function buildOrderMessage(payload) {
    var lines = [
      'Bonjour, je souhaite confirmer une commande.',
      'Nom: ' + payload.name,
      'Téléphone: ' + payload.phone,
      'Ville: ' + payload.city,
      'Produit/Lien: ' + payload.product
    ];
    if (payload.notes) lines.push('Détails: ' + payload.notes);
    return lines.join('\n');
  }

  function redirectToWhatsapp(url) {
    if (!url) return;
    window.location.assign(url);
  }

  function setupOrderForm() {
    var form = getElement('order-form');
    var contact = contentService.getContact();
    if (!form) return;

    form.addEventListener('submit', async function(event) {
      event.preventDefault();
      if (!form.reportValidity()) return;

      var formData = new FormData(form);
      var payload = {
        name: String(formData.get('name') || '').trim(),
        phone: String(formData.get('phone') || '').trim(),
        city: String(formData.get('city') || '').trim(),
        product: String(formData.get('product') || '').trim(),
        notes: String(formData.get('notes') || '').trim()
      };

      trackEvent('form_submit_attempt', { channel: 'form' });
      var whatsappMessage = buildOrderMessage(payload);
      var whatsappUrl = buildWhatsappUrl(whatsappMessage);
      var endpoint = typeof contact.formEndpoint === 'string' ? contact.formEndpoint.trim() : '';

      if (!endpoint) {
        trackEvent('form_submit_failure', { reason: 'missing_endpoint' });
        if (whatsappUrl) {
          showFormFeedback('error', 'Formulaire non connecté. Redirection vers WhatsApp...');
          redirectToWhatsapp(whatsappUrl);
        } else {
          showFormFeedback('error', 'Formulaire non connecté. Merci de contacter le bureau Betongolo.');
        }
        return;
      }

      try {
        var response = await fetch(endpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        if (!response.ok) throw new Error('Failed: ' + response.status);
        showFormFeedback('success', 'Commande envoyée. Merci, nous revenons vers vous rapidement.');
        form.reset();
      } catch (error) {
        trackEvent('form_submit_failure', { reason: 'network_error' });
        if (whatsappUrl) {
          showFormFeedback('error', 'Échec. Redirection vers WhatsApp...');
          redirectToWhatsapp(whatsappUrl);
        } else {
          showFormFeedback('error', 'Échec. Merci de nous contacter via les réseaux sociaux.');
        }
      }
    });
  }

  function setupMobileCtaVisibility() {
    var mobileBar = getElement('mobile-cta-bar');
    var form = getElement('order-form');
    var mobileCta = contentService.getMobileCta();
    if (!mobileBar || !form || !mobileCta.hideOnFormFocus) return;

    form.addEventListener('focusin', function() {
      mobileBar.classList.add('is-hidden');
    });
    form.addEventListener('focusout', function() {
      window.setTimeout(function() {
        var active = document.activeElement;
        if (!active || !form.contains(active)) {
          mobileBar.classList.remove('is-hidden');
        }
      }, 10);
    });
  }

  function setupRevealObserver() {
    var revealElements = document.querySelectorAll('[data-reveal]');
    if (!revealElements.length) return;

    if (!('IntersectionObserver' in window)) {
      revealElements.forEach(function(el) { el.classList.add('is-visible'); });
      return;
    }

    var observer = new IntersectionObserver(
      function(entries, obs) {
        entries.forEach(function(entry) {
          if (!entry.isIntersecting) return;
          var parent = entry.target.parentElement;
          if (parent) {
            var siblings = parent.querySelectorAll('[data-reveal]');
            var idx = Array.prototype.indexOf.call(siblings, entry.target);
            if (idx > 0) entry.target.style.transitionDelay = (idx * 80) + 'ms';
          }
          entry.target.classList.add('is-visible');
          obs.unobserve(entry.target);
        });
      },
      { rootMargin: '0px 0px -8% 0px', threshold: 0.08 }
    );

    revealElements.forEach(function(el) { observer.observe(el); });
  }

  function bindCtaTracking() {
    document.querySelectorAll('[data-track-cta]').forEach(function(el) {
      el.addEventListener('click', function() {
        trackEvent('cta_click', { label: el.getAttribute('data-track-cta') || 'unknown' });
      });
    });
  }

  function renderEverything() {
    renderNavigation();
    renderHero();
    renderTrustArea();
    renderServices();
    renderCatalog();
    renderProcess();
    renderTestimonials();
    renderCtaBanner();
    renderAbout();
    renderVideo();
    renderOrderHeader();
    renderOrderContactCard();
    renderFaq();
    renderFooter();
    renderMobileCtaBar();
  }

  function initializePage() {
    renderEverything();
    bindCtaTracking();
    setupOrderForm();
    setupFaqAccordion();
    setupMobileCtaVisibility();
    setupRevealObserver();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializePage);
  } else {
    initializePage();
  }
})();
