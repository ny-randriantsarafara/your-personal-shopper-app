window.CONTENT = Object.freeze({
  designTheme: Object.freeze({
    palette: Object.freeze({
      bg: '#0f1115',
      surface: '#f5f1e8',
      surfaceAlt: '#ece6d8',
      ink: '#1b1711',
      accent: '#d8a81a',
      safe: '#0f766e'
    }),
    radii: Object.freeze({
      card: '0.8rem',
      button: '0.65rem'
    }),
    shadows: Object.freeze({
      card: '0 10px 28px rgba(15, 17, 21, 0.1)',
      cta: '0 8px 18px rgba(216, 168, 26, 0.28)'
    }),
    contrastMode: 'high',
    textures: Object.freeze({
      hero: 'grain-grid',
      trust: 'soft-lines'
    })
  }),

  mobileCta: Object.freeze({
    primaryLabel: Object.freeze({
      fr: 'Commander WhatsApp',
      mg: 'Hanafatra WhatsApp'
    }),
    secondaryLabel: Object.freeze({
      fr: 'Formulaire rapide',
      mg: 'Formulaire haingana'
    }),
    trustStatus: Object.freeze({
      fr: 'Entreprise déclarée · Betongolo',
      mg: 'Orinasa voasoratra · Betongolo'
    }),
    showOnSections: Object.freeze(['home', 'services', 'catalogue', 'how-it-works', 'testimonials', 'about', 'faq']),
    hideOnFormFocus: true
  }),

  tone: Object.freeze({
    heroStyle: 'authoritative_warm',
    ctaStyle: 'direct_action',
    trustLabelStyle: 'evidence_first',
    sectionVoice: 'simple_confident'
  }),

  site: Object.freeze({
    brand: 'Personal Shopper France → Madagascar',
    tagline: Object.freeze({
      fr: 'Pro, rapide, traçable. Vos commandes France arrivent sans stress.',
      mg: 'Matihanina, haingana, azo arahina. Tonga tsy misy adin-tsaina ny kaomandy avy any Frantsa.'
    }),
    defaultLocale: 'fr',
    whatsappNumber: '261340000000',
    defaultWhatsappMessage: Object.freeze({
      fr: 'Bonjour, je veux lancer une commande France → Madagascar.',
      mg: 'Salama, te hanomboka kaomandy France → Madagascar aho.'
    }),
    nav: Object.freeze([
      Object.freeze({ href: '#home', label: Object.freeze({ fr: 'Accueil', mg: 'Fandraisana' }) }),
      Object.freeze({ href: '#services', label: Object.freeze({ fr: 'Services', mg: 'Tolotra' }) }),
      Object.freeze({ href: '#catalogue', label: Object.freeze({ fr: 'Tendances', mg: 'Firona' }) }),
      Object.freeze({ href: '#how-it-works', label: Object.freeze({ fr: 'Étapes', mg: 'Dingana' }) }),
      Object.freeze({ href: '#order', label: Object.freeze({ fr: 'Commander', mg: 'Hanafatra' }) }),
      Object.freeze({ href: '#faq', label: Object.freeze({ fr: 'FAQ', mg: 'FAQ' }) })
    ]),
    legal: Object.freeze({
      office: Object.freeze({
        fr: 'Bureau: Betongolo, Antananarivo',
        mg: 'Birao: Betongolo, Antananarivo'
      }),
      nif: 'NIF: 000 000 0000',
      stat: 'STAT: 00000 11 2025 0 00000',
      payment: Object.freeze({
        fr: 'Paiement sécurisé: mobile money, virement, espèces au bureau.',
        mg: 'Fandoavana azo antoka: mobile money, virement, na vola mivantana.'
      })
    }),
    socials: Object.freeze([
      Object.freeze({ name: 'Facebook', url: 'https://facebook.com', label: '46K+ communauté' }),
      Object.freeze({ name: 'Instagram', url: 'https://instagram.com', label: 'Stories quotidiennes' }),
      Object.freeze({ name: 'TikTok', url: 'https://tiktok.com', label: 'Arrivages en vidéo' })
    ]),
    quickLinks: Object.freeze([
      Object.freeze({ href: '#services', label: Object.freeze({ fr: 'Services', mg: 'Tolotra' }) }),
      Object.freeze({ href: '#catalogue', label: Object.freeze({ fr: 'Catalogue', mg: 'Katalogy' }) }),
      Object.freeze({ href: '#order', label: Object.freeze({ fr: 'Commande', mg: 'Kaomandy' }) }),
      Object.freeze({ href: '#faq', label: Object.freeze({ fr: 'FAQ', mg: 'FAQ' }) })
    ])
  }),

  hero: Object.freeze({
    badge: Object.freeze({
      fr: 'France → Madagascar · Service cadré, résultat clair',
      mg: 'France → Madagascar · Tolotra voalamina, valiny mazava'
    }),
    title: Object.freeze({
      fr: 'Vous voulez le bon produit. Nous livrons sans improvisation.',
      mg: 'Te hahazo vokatra tsara ianao. Izahay manatitra tsy kisendrasendra.'
    }),
    subtitle: Object.freeze({
      fr: 'Devis net, achat vérifié, suivi réel, livraison maîtrisée. Vous avancez avec des preuves, pas des promesses.',
      mg: 'Devis mazava, fividianana voamarina, fanaraha-maso tena izy, fandefasana voafehy. Porofon-javatra no entinay, fa tsy teny fotsiny.'
    }),
    ctaPrimary: Object.freeze({
      fr: 'Lancer ma commande',
      mg: 'Hanomboka kaomandy'
    }),
    ctaSecondary: Object.freeze({
      fr: 'Demander un devis',
      mg: 'Mangataka devis'
    }),
    image: './assets/hero-johanna.svg',
    mapOverlay: './assets/madagascar-overlay.svg',
    microProofs: Object.freeze([
      'Bureau réel à Betongolo',
      'Achat validé avant paiement final',
      'Suivi régulier jusqu\'à réception'
    ])
  }),

  trustTimeline: Object.freeze([
    Object.freeze({
      step: '01',
      icon: '🧾',
      title: Object.freeze({ fr: 'Base légale claire', mg: 'Fototra ara-dalàna mazava' }),
      detail: Object.freeze({
        fr: 'NIF/STAT disponibles et communication transparente.',
        mg: 'NIF/STAT hita ary fifandraisana mangarahara.'
      })
    }),
    Object.freeze({
      step: '02',
      icon: '🏢',
      title: Object.freeze({ fr: 'Présence physique', mg: 'Fisiana ara-batana' }),
      detail: Object.freeze({
        fr: 'Bureau à Betongolo pour relation client structurée.',
        mg: 'Birao ao Betongolo ho an\'ny fifandraisana voalamina amin\'ny mpanjifa.'
      })
    }),
    Object.freeze({
      step: '03',
      icon: '📲',
      title: Object.freeze({ fr: 'Preuves en continu', mg: 'Porofo mitohy' }),
      detail: Object.freeze({
        fr: 'Photos, confirmations, suivi WhatsApp à chaque étape.',
        mg: 'Sary, fanamafisana, fanaraha-maso WhatsApp isaky ny dingana.'
      })
    })
  ]),

  trustSignals: Object.freeze([
    Object.freeze({
      icon: '👥',
      value: '46K+',
      label: Object.freeze({ fr: 'Audience active', mg: 'Vondrona mavitrika' }),
      detail: Object.freeze({ fr: 'Communauté sociale engagée', mg: 'Vondrom-piarahamonina mavitrika' })
    }),
    Object.freeze({
      icon: '🏢',
      value: 'Betongolo',
      label: Object.freeze({ fr: 'Bureau physique', mg: 'Birao ara-batana' }),
      detail: Object.freeze({ fr: 'Rendez-vous client possible', mg: 'Azo atao ny fotoana miaraka amin\'ny mpanjifa' })
    }),
    Object.freeze({
      icon: '🧾',
      value: 'NIF/STAT',
      label: Object.freeze({ fr: 'Entreprise déclarée', mg: 'Orinasa voasoratra' }),
      detail: Object.freeze({ fr: 'Cadre légal transparent', mg: 'Mangarahara ara-dalàna' })
    }),
    Object.freeze({
      icon: '🔐',
      value: 'Sécurisé',
      label: Object.freeze({ fr: 'Paiement contrôlé', mg: 'Fandoavana voafehy' }),
      detail: Object.freeze({ fr: 'Modes fiables et traçables', mg: 'Fomba azo antoka sy azo arahina' })
    })
  ]),

  services: Object.freeze({
    title: Object.freeze({ fr: 'Ce que nous gérons pour vous', mg: 'Izay tantaninay ho anao' }),
    subtitle: Object.freeze({
      fr: 'Un service orienté résultat: moins de risques, plus de clarté.',
      mg: 'Tolotra mifantoka amin\'ny vokatra: loza kely kokoa, mazava kokoa.'
    }),
    items: Object.freeze([
      Object.freeze({
        icon: '👗',
        name: Object.freeze({ fr: 'Mode femme/homme', mg: 'Lamaody vehivavy/lehilahy' }),
        detail: Object.freeze({
          fr: 'Pièces tendances, tailles vérifiées, qualité contrôlée.',
          mg: 'Vokatra lamaody, taille voamarina, kalitao voafehy.'
        })
      }),
      Object.freeze({
        icon: '💄',
        name: Object.freeze({ fr: 'Beauté & soins', mg: 'Hatsaran-tarehy sy fikarakarana' }),
        detail: Object.freeze({
          fr: 'Produits authentiques, lots cohérents, origine claire.',
          mg: 'Vokatra tena izy, lot mifanaraka, fiaviana mazava.'
        })
      }),
      Object.freeze({
        icon: '📱',
        name: Object.freeze({ fr: 'Électronique', mg: 'Elektronika' }),
        detail: Object.freeze({
          fr: 'Vérification compatibilité et conformité avant départ.',
          mg: 'Fanamarinana mialoha ny fifanarahana sy ny fahamarinan\'ny entana.'
        })
      }),
      Object.freeze({
        icon: '🧸',
        name: Object.freeze({ fr: 'Bébé & enfant', mg: 'Zazakely sy ankizy' }),
        detail: Object.freeze({
          fr: 'Articles pratiques et sûrs pour le quotidien.',
          mg: 'Entana azo antoka sy ilaina amin\'ny andavanandro.'
        })
      }),
      Object.freeze({
        icon: '🏷️',
        name: Object.freeze({ fr: 'Marques premium', mg: 'Marika premium' }),
        detail: Object.freeze({
          fr: 'Recherche ciblée selon budget et authenticité.',
          mg: 'Fikarohana mifanaraka amin\'ny teti-bola sy maha-azo antoka.'
        })
      })
    ])
  }),

  catalogItems: Object.freeze([
    Object.freeze({
      id: 'cat-1',
      name: Object.freeze({ fr: 'Sac à main tendance', mg: 'Kitapo lamaody' }),
      price: Object.freeze({ fr: 'À partir de 290 000 Ar', mg: 'Manomboka amin\'ny 290 000 Ar' }),
      delivery: Object.freeze({ fr: '3-4 semaines', mg: '3-4 herinandro' }),
      image: './assets/product-bag.svg',
      category: Object.freeze({ fr: 'Mode', mg: 'Lamaody' })
    }),
    Object.freeze({
      id: 'cat-2',
      name: Object.freeze({ fr: 'Coffret skincare', mg: 'Coffret fikarakarana hoditra' }),
      price: Object.freeze({ fr: 'À partir de 180 000 Ar', mg: 'Manomboka amin\'ny 180 000 Ar' }),
      delivery: Object.freeze({ fr: '2-3 semaines', mg: '2-3 herinandro' }),
      image: './assets/product-beauty.svg',
      category: Object.freeze({ fr: 'Beauté', mg: 'Hatsaran-tarehy' })
    }),
    Object.freeze({
      id: 'cat-3',
      name: Object.freeze({ fr: 'Écouteurs sans fil', mg: 'Ecouteurs tsy misy tariby' }),
      price: Object.freeze({ fr: 'À partir de 210 000 Ar', mg: 'Manomboka amin\'ny 210 000 Ar' }),
      delivery: Object.freeze({ fr: '3 semaines', mg: '3 herinandro' }),
      image: './assets/product-tech.svg',
      category: Object.freeze({ fr: 'Électronique', mg: 'Elektronika' })
    }),
    Object.freeze({
      id: 'cat-4',
      name: Object.freeze({ fr: 'Kit naissance', mg: 'Kit ho an\'ny zaza vao teraka' }),
      price: Object.freeze({ fr: 'À partir de 240 000 Ar', mg: 'Manomboka amin\'ny 240 000 Ar' }),
      delivery: Object.freeze({ fr: '3-4 semaines', mg: '3-4 herinandro' }),
      image: './assets/product-baby.svg',
      category: Object.freeze({ fr: 'Bébé/Enfant', mg: 'Zaza/Ankizy' })
    }),
    Object.freeze({
      id: 'cat-5',
      name: Object.freeze({ fr: 'Sneakers originales', mg: 'Sneakers tena izy' }),
      price: Object.freeze({ fr: 'À partir de 320 000 Ar', mg: 'Manomboka amin\'ny 320 000 Ar' }),
      delivery: Object.freeze({ fr: '3-5 semaines', mg: '3-5 herinandro' }),
      image: './assets/product-shoes.svg',
      category: Object.freeze({ fr: 'Marques', mg: 'Marika' })
    }),
    Object.freeze({
      id: 'cat-6',
      name: Object.freeze({ fr: 'Parfum signature', mg: 'Menaka manitra signature' }),
      price: Object.freeze({ fr: 'À partir de 260 000 Ar', mg: 'Manomboka amin\'ny 260 000 Ar' }),
      delivery: Object.freeze({ fr: '2-4 semaines', mg: '2-4 herinandro' }),
      image: './assets/product-perfume.svg',
      category: Object.freeze({ fr: 'Beauté', mg: 'Hatsaran-tarehy' })
    })
  ]),

  processSteps: Object.freeze({
    title: Object.freeze({ fr: 'Commande en 5 étapes nettes', mg: 'Kaomandy amin\'ny dingana 5 mazava' }),
    subtitle: Object.freeze({
      fr: 'Vous savez où vous en êtes à chaque instant.',
      mg: 'Fantatrao foana ny toerana misy ny kaomandinao.'
    }),
    items: Object.freeze([
      Object.freeze({
        title: Object.freeze({ fr: '1. Besoin', mg: '1. Filàna' }),
        detail: Object.freeze({ fr: 'Photo, lien ou référence.', mg: 'Sary, rohy na référence.' })
      }),
      Object.freeze({
        title: Object.freeze({ fr: '2. Devis', mg: '2. Devis' }),
        detail: Object.freeze({ fr: 'Prix + délai + validation.', mg: 'Vidiny + fe-potoana + fanamafisana.' })
      }),
      Object.freeze({
        title: Object.freeze({ fr: '3. Lancement', mg: '3. Fanombohana' }),
        detail: Object.freeze({ fr: 'Acompte et achat confirmé.', mg: 'Acompte sy fividianana voamarina.' })
      }),
      Object.freeze({
        title: Object.freeze({ fr: '4. Suivi', mg: '4. Fanaraha-maso' }),
        detail: Object.freeze({ fr: 'Preuves régulières.', mg: 'Porofo tsy tapaka.' })
      }),
      Object.freeze({
        title: Object.freeze({ fr: '5. Livraison', mg: '5. Fandefasana' }),
        detail: Object.freeze({ fr: 'Retrait bureau ou remise.', mg: 'Fakana birao na fanaterana.' })
      })
    ])
  }),

  testimonials: Object.freeze({
    title: Object.freeze({ fr: 'Retour clients vérifiables', mg: 'Hevitry ny mpanjifa azo hamarinina' }),
    subtitle: Object.freeze({
      fr: 'Ce qui revient le plus: clarté, suivi, sérénité.',
      mg: 'Ny miverimberina: mazava, fanaraha-maso, fitoniana.'
    }),
    items: Object.freeze([
      Object.freeze({
        author: 'Mialy R.',
        source: 'Facebook',
        quote: Object.freeze({
          fr: 'Commande reçue sans surprise. Tout était annoncé à l\'avance.',
          mg: 'Voaray tsara ny kaomandy. Efa voalaza mialoha ny zava-drehetra.'
        })
      }),
      Object.freeze({
        author: 'Toky H.',
        source: 'Instagram',
        quote: Object.freeze({
          fr: 'J\'ai suivi chaque étape sur WhatsApp, c\'est rassurant.',
          mg: 'Nahazo fanaraha-maso isaky ny dingana tamin\'ny WhatsApp aho, tena mampatoky.'
        })
      }),
      Object.freeze({
        author: 'Hanitra L.',
        source: 'TikTok',
        quote: Object.freeze({
          fr: 'Service sérieux, rapide et humain.',
          mg: 'Tolotra matotra, haingana ary akaiky ny mpanjifa.'
        })
      })
    ])
  }),

  about: Object.freeze({
    title: Object.freeze({ fr: 'F.R.I.D.A.Y, votre point de contrôle', mg: 'F.R.I.D.A.Y, ivon\'ny fanaraha-maso anao' }),
    summary: Object.freeze({
      fr: 'Notre mission: sécuriser vos achats France → Madagascar avec méthode, preuves et communication humaine.',
      mg: 'Ny tanjonay: miaro sy mandamina ny fividiananao France → Madagascar amin\'ny fomba voalamina, porofo ary fifandraisana akaiky.'
    }),
    highlights: Object.freeze([
      Object.freeze({
        fr: 'Validation client obligatoire avant achat final.',
        mg: 'Ilaina ny fanamafisan\'ny mpanjifa alohan\'ny fividianana farany.'
      }),
      Object.freeze({
        fr: 'Preuve d\'achat et suivi clairs.',
        mg: 'Misy porofon\'ny fividianana sy fanaraha-maso mazava.'
      }),
      Object.freeze({
        fr: 'Relation client rapide sur WhatsApp.',
        mg: 'Fifandraisana haingana amin\'ny mpanjifa amin\'ny WhatsApp.'
      })
    ])
  }),

  contact: Object.freeze({
    title: Object.freeze({ fr: 'Contact & commande', mg: 'Fifandraisana sy kaomandy' }),
    subtitle: Object.freeze({
      fr: 'Canal conseillé: WhatsApp. Formulaire disponible en alternative.',
      mg: 'Lalan-kifandraisana atolotra: WhatsApp. Misy koa ny formulaire.'
    }),
    whatsappLabel: Object.freeze({
      fr: 'Parler sur WhatsApp',
      mg: 'Hiresaka amin\'ny WhatsApp'
    }),
    fallbackText: Object.freeze({
      fr: 'WhatsApp indisponible. Utilisez le formulaire pour être rappelé(e).',
      mg: 'Tsy mandeha ny WhatsApp. Ampiasao ny formulaire mba hiverenanay aminao.'
    }),
    formEndpoint: ''
  }),

  faq: Object.freeze({
    title: Object.freeze({ fr: 'FAQ pratique', mg: 'FAQ ilaina' }),
    subtitle: Object.freeze({
      fr: 'Réponses courtes aux questions qui bloquent souvent.',
      mg: 'Valiny fohy ho an\'ireo fanontaniana manahirana matetika.'
    }),
    items: Object.freeze([
      Object.freeze({
        question: Object.freeze({ fr: 'Comment sont calculés les frais de douane ?', mg: 'Ahoana no kajiana ny sara ladoany?' }),
        answer: Object.freeze({
          fr: 'Selon catégorie et valeur produit. Le devis détaillé arrive avant validation.',
          mg: 'Miankina amin\'ny sokajy sy sandan\'entana. Alefa mialoha ny fanamafisana ny devis feno.'
        })
      }),
      Object.freeze({
        question: Object.freeze({ fr: 'Quel délai moyen de livraison ?', mg: 'Ohatrinona ny fe-potoana fandefasana?' }),
        answer: Object.freeze({
          fr: 'En général 2 à 5 semaines selon période et catégorie.',
          mg: 'Amin\'ny ankapobeny 2 hatramin\'ny 5 herinandro arakaraka ny vanim-potoana sy ny sokajy.'
        })
      }),
      Object.freeze({
        question: Object.freeze({ fr: 'Y a-t-il un acompte ?', mg: 'Misy acompte ve?' }),
        answer: Object.freeze({
          fr: 'Oui, après validation du devis pour sécuriser l\'achat.',
          mg: 'Eny, aorian\'ny fanekena ny devis mba hiantohana ny fividianana.'
        })
      }),
      Object.freeze({
        question: Object.freeze({ fr: 'Que faire si le produit est indisponible ?', mg: 'Inona no atao raha tsy misy intsony ny vokatra?' }),
        answer: Object.freeze({
          fr: 'Nous proposons une alternative ou un remboursement selon votre choix.',
          mg: 'Manolotra safidy hafa na famerenam-bola araka ny safidinao izahay.'
        })
      }),
      Object.freeze({
        question: Object.freeze({ fr: 'Acceptez-vous les retours ?', mg: 'Manaiky famerenana entana ve ianareo?' }),
        answer: Object.freeze({
          fr: 'Étude au cas par cas selon type produit et état à réception.',
          mg: 'Dinihina tsirairay arakaraka ny karazan\'entana sy ny toetrany rehefa voaray.'
        })
      })
    ])
  }),

  video: Object.freeze({
    title: Object.freeze({ fr: 'Une commande réelle en vidéo', mg: 'Kaomandy tena izy amin\'ny vidéo' }),
    description: Object.freeze({
      fr: 'Arrivages, preuves de remise et retours clients sur les réseaux.',
      mg: 'Fahatongavan\'entana, porofon\'ny fanaterana ary hevitry ny mpanjifa amin\'ny tambajotra.'
    }),
    embedUrl: '',
    thumbnail: './assets/video-thumb.svg',
    externalUrl: 'https://instagram.com'
  })
});
