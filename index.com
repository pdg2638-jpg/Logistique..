<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>International Transfer Pro — Expédition Globale</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <!-- Inclusion de la librairie QR Code externe officielle -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

  <style>
    :root {
      --bg: #f8fafc;
      --card-bg: #ffffff;
      --text: #0f172a;
      --muted: #64748b;
      --primary: #0284c7;
      --primary-gradient: linear-gradient(135deg, #0ea5e9, #2563eb);
      --whatsapp-green: #22c55e;
      --whatsapp-gradient: linear-gradient(135deg, #22c55e, #16a34a);
      --line: #e2e8f0;
      --shadow: 0 20px 40px -15px rgba(148, 163, 184, 0.15);
      --radius: 20px;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background: radial-gradient(circle at top right, rgba(14, 165, 233, 0.08), transparent 40%), var(--bg);
      color: var(--text); padding: 40px 20px; min-height: 100vh;
    }

    .container { max-width: 1280px; margin: 0 auto; display: flex; flex-direction: column; gap: 30px; }
    
    header {
      background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.8); border-radius: var(--radius);
      padding: 30px; box-shadow: var(--shadow); display: flex; justify-content: space-between; align-items: center;
    }
    .logo-area { display: flex; align-items: center; gap: 15px; }
    .logo { width: 50px; height: 50px; background: var(--primary-gradient); color: #fff; display: grid; place-items: center; font-weight: 800; border-radius: 14px; box-shadow: 0 8px 20px rgba(14, 165, 233, 0.3); }
    header h1 { font-size: 22px; font-weight: 800; letter-spacing: -0.5px; }
    header p { color: var(--muted); font-size: 13px; margin-top: 2px; }

    .grid-layout { display: grid; grid-template-columns: 1.3fr 1fr; gap: 30px; }
    .card { background: var(--card-bg); border: 1px solid var(--line); border-radius: var(--radius); padding: 30px; box-shadow: var(--shadow); transition: transform 0.3s ease; }
    
    .section-title { font-size: 18px; font-weight: 700; margin-bottom: 24px; position: relative; padding-left: 12px; }
    .section-title::before { content: ''; position: absolute; left: 0; top: 4px; bottom: 4px; width: 4px; background: var(--primary-gradient); border-radius: 2px; }

    .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 18px; }
    .field { display: flex; flex-direction: column; gap: 8px; }
    .label { font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }
    .input, .select { width: 100%; padding: 14px; border: 1px solid var(--line); background: #f8fafc; border-radius: 12px; font-size: 14px; color: var(--text); outline: none; transition: all 0.2s ease; }
    .input:focus, .select:focus { border-color: #0ea5e9; background: #fff; box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1); }

    .btn { border: none; padding: 16px 24px; border-radius: 14px; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.25s ease; display: inline-flex; align-items: center; justify-content: center; gap: 10px; text-decoration: none; }
    .btn-primary { background: var(--primary-gradient); color: white; box-shadow: 0 10px 25px rgba(37, 99, 235, 0.2); }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 12px 30px rgba(37, 99, 235, 0.3); }
    .btn-whatsapp { background: var(--whatsapp-gradient); color: white; box-shadow: 0 10px 25px rgba(34, 197, 94, 0.2); margin-top: 15px; width: 100%; display: none; }
    .btn-whatsapp:hover { transform: translateY(-2px); box-shadow: 0 12px 30px rgba(34, 197, 94, 0.3); }

    /* Panneau de cotation et étiquette */
    .result-panel { display: flex; flex-direction: column; gap: 24px; }
    .price-display { text-align: center; padding: 30px; border-radius: 16px; background: linear-gradient(180deg, #f0fdf4, #ffffff); border: 1px solid #bbf7d0; margin-bottom: 20px; }
    .price-display h4 { font-size: 14px; color: #166534; text-transform: uppercase; letter-spacing: 1px; }
    .price-display .amount { font-size: 42px; font-weight: 900; color: #15803d; margin: 10px 0; }

    /* Structure Étiquette Thermique Brillant/Pro */
    .shipping-label { background: #fff; border: 2px dashed #0f172a; padding: 24px; border-radius: 12px; color: #000; font-family: monospace; display: none; box-shadow: var(--shadow); position: relative; overflow: hidden; }
    .shipping-label::after { content: ''; position: absolute; top: 0; left: -100%; width: 50%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.6), transparent); transform: skewX(-25deg); animation: shine 4s infinite; }
    @keyframes shine { 100% { left: 200%; } }
    
    .label-header { display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 12px; margin-bottom: 12px; }
    .label-title { font-size: 18px; font-weight: 800; }
    .label-body { display: grid; grid-template-columns: 1fr 100px; gap: 10px; align-items: center; }
    .label-info p { font-size: 12px; margin-bottom: 6px; }
    .qrcode-wrapper { width: 100px; height: 100px; background: #fff; padding: 4px; border: 1px solid #000; }

    @media (max-width: 980px) { .grid-layout { grid-template-columns: 1fr; } }
  </style>
</head>
<body>

  <div class="container">
    <header>
      <div class="logo-area">
        <div class="logo">IT</div>
        <div>
          <h1>International Transfer Pro</h1>
          <p>Calculateur d'expédition internationale grand public</p>
        </div>
      </div>
      <div class="pill yellow" style="background: #e0f2fe; color: #0369a1; font-weight: 700; padding: 8px 16px; border-radius: 20px; font-size: 12px;">Tarification Certifiée</div>
    </header>

    <div class="grid-layout">
      <!-- FORMULAIRE -->
      <div class="card">
        <h3 class="section-title">Caractéristiques du colis</h3>
        <div class="form-grid">
          <div class="field"><label class="label">Origine</label><select class="select" id="originCountry"></select></div>
          <div class="field"><label class="label">Destination</label><select class="select" id="destinationCountry"></select></div>
          <div class="field"><label class="label">Hub Destination</label>
            <select class="select" id="destinationHub">
              <option value="standard">Standard</option><option value="kuwait_city">Koweït City</option>
              <option value="dubai">Dubaï</option><option value="abu_dhabi">Abu Dhabi</option>
              <option value="remote">Zone éloignée</option>
            </select>
          </div>
          <div class="field"><label class="label">Transporteur</label>
            <select class="select" id="carrier">
              <option value="DHL">DHL Express</option><option value="FedEx">FedEx</option>
              <option value="UPS">UPS</option><option value="Aramex">Aramex</option><option value="EMS">EMS</option>
            </select>
          </div>
          <div class="field"><label class="label">Poids réel (kg)</label><input class="input" id="actualWeight" type="number" step="0.1" value="2.5"></div>
          <div class="field"><label class="label">Longueur (cm)</label><input class="input" id="length" type="number" value="35"></div>
          <div class="field"><label class="label">Largeur (cm)</label><input class="input" id="width" type="number" value="28"></div>
          <div class="field"><label class="label">Hauteur (cm)</label><input class="input" id="height" type="number" value="18"></div>
          <div class="field">
            <label class="label">Type d’envoi</label>
            <select class="select" id="shipmentType">
              <option value="documents">Documents</option><option value="parcel" selected>Colis</option><option value="sensitive">Marchandise sensible</option>
            </select>
          </div>
          <div class="field"><label class="label">Valeur Déclarée (USD)</label><input class="input" id="declaredValue" type="number" value="180"></div>
        </div>

        <div style="margin-top: 24px;">
          <button class="btn btn-primary" id="calculateBtn" style="width: 100%;">Générer ma Cotation & mon Étiquette</button>
        </div>
      </div>

      <!-- RÉSULTAT ET REDIRECTION -->
      <div class="result-panel">
        <div class="card">
          <div class="price-display">
            <h4>Estimation Tarif Public</h4>
            <div class="amount" id="resPublicPrice">0.00 USD</div>
            <p style="color: var(--muted); font-size: 12px;" id="taxableWeightText">Remplissez les informations à gauche.</p>
          </div>

          <!-- L'étiquette de livraison générée -->
          <div class="shipping-label" id="shippingLabel">
            <div class="label-header">
              <div>
                <span class="label-title" id="lblCarrier">DHL</span>
                <p style="font-size: 10px; margin-top: 2px;" id="lblId">ID: ITEM-0000</p>
              </div>
              <div style="text-align: right; font-weight: bold; font-size: 14px;">PRIORITY</div>
            </div>
            <div class="label-body">
              <div class="label-info">
                <p><strong>ORIGINE:</strong> <span id="lblOrig">—</span></p>
                <p><strong>DESTINATION:</strong> <span id="lblDest">—</span></p>
                <p><strong>POIDS CHARGÉ:</strong> <span id="lblWeight">—</span></p>
                <p style="font-size: 9px; color: #555; margin-top: 8px;">Généré par International Transfer Pro. Sécurisé IATA.</p>
              </div>
              <div class="qrcode-wrapper">
                <div id="qrcode"></div>
              </div>
            </div>
          </div>

          <!-- Lien WhatsApp dynamique -->
          <a href="#" target="_blank" class="btn btn-whatsapp" id="whatsappBtn">
            💬 Finaliser et Payer sur WhatsApp
          </a>
        </div>
      </div>
    </div>
  </div>

  <script>
    const API_URL = "http://localhost:3000/api";
    // Remplace par ton vrai numéro WhatsApp au format international (ex: 33612345678)
    const WHATSAPP_NUMBER = "905395856977"; 

    const countries = [
      { code: "SN", name: "Sénégal", region: "Afrique" }, { code: "FR", name: "France", region: "Europe" },
      { code: "KW", name: "Koweït", region: "Asie" }, { code: "AE", name: "Émirats arabes unis", region: "Asie" },
      { code: "AU", name: "Australie", region: "Océanie" }
    ];

    let qrcodeInstance = null;

    function init() {
      const orig = document.getElementById('originCountry');
      const dest = document.getElementById('destinationCountry');
      countries.forEach(c => {
        orig.add(new Option(`${c.name} (${c.region})`, c.code));
        dest.add(new Option(`${c.name} (${c.region})`, c.code));
      });
      orig.value = "FR"; dest.value = "AE";
    }

    async function executeQuote() {
      const origin = countries.find(c => c.code === document.getElementById('originCountry').value);
      const dest = countries.find(c => c.code === document.getElementById('destinationCountry').value);

      const payload = {
        originRegion: origin.region, destinationRegion: dest.region,
        originCountryName: origin.name, destinationCountryName: dest.name,
        destinationCountryCode: dest.code,
        destinationHub: document.getElementById('destinationHub').value,
        carrier: document.getElementById('carrier').value,
        actualWeight: document.getElementById('actualWeight').value,
        length: document.getElementById('length').value,
        width: document.getElementById('width').value,
        height: document.getElementById('height').value,
        shipmentType: document.getElementById('shipmentType').value,
        declaredValue: document.getElementById('declaredValue').value
      };

      try {
        const res = await fetch(`${API_URL}/quote`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload)
        });
        const data = await res.json();

        if (data.error) return alert(data.error);

        // 1. Affichage du prix public de vente
        document.getElementById('resPublicPrice').textContent = `${data.publicPrice.toFixed(2)} USD`;
        document.getElementById('taxableWeightText').textContent = `Facturé sur la base de ${data.taxableWeight} kg (Poids volumétrique: ${data.volumetricWeight} kg)`;

        // 2. Hydratation de l'étiquette d'envoi thermique
        document.getElementById('lblCarrier').textContent = data.carrier;
        document.getElementById('lblId').textContent = `BORDEREAU: ${data.parcelId}`;
        document.getElementById('lblOrig').textContent = data.origin;
        document.getElementById('lblDest').textContent = data.destination;
        document.getElementById('lblWeight').textContent = `${data.taxableWeight} KG`;
        document.getElementById('shippingLabel').style.display = "block";

        // 3. Génération dynamique du QR Code
        const qrContainer = document.getElementById("qrcode");
        qrContainer.innerHTML = ""; // Clear précédent
        qrcodeInstance = new QRCode(qrContainer, {
          text: `PARCEL-ID:${data.parcelId}|CARRIER:${data.carrier}|WEIGHT:${data.taxableWeight}KG|PRICE:${data.publicPrice}USD`,
          width: 92,
          height: 92,
          colorDark : "#000000",
          colorLight : "#ffffff",
          correctLevel : QRCode.CorrectLevel.H
        });

        // 4. Configuration du bouton de redirection WhatsApp
        const textMessage = `Bonjour, je souhaite valider mon expédition.\n\n` +
                            `📦 *Bordereau :* ${data.parcelId}\n` +
                            `🚚 *Transporteur :* ${data.carrier}\n` +
                            `🗺️ *Trajet :* ${data.origin} ➔ ${data.destination}\n` +
                            `⚖️ *Poids facturable :* ${data.taxableWeight} kg\n` +
                            `💰 *Tarif total :* ${data.publicPrice} USD\n\n` +
                            `Merci de m'indiquer les modalités de paiement.`;
        
        const encodedText = encodeURIComponent(textMessage);
        const whatsappBtn = document.getElementById('whatsappBtn');
        whatsappBtn.href = `https://wa.me/${WHATSAPP_NUMBER}?text=${encodedText}`;
        whatsappBtn.style.display = "inline-flex";

      } catch (err) {
        alert("Connexion impossible avec le serveur API logistique backend.");
      }
    }

    document.getElementById('calculateBtn').addEventListener('click', executeQuote);
    init();
  </script>
</body>
</html>
