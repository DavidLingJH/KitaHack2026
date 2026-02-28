const prompt_button = document.getElementById('prompt');
const send_button = document.getElementById('send');
const textbox_div = document.getElementById('textbox');
const loc_button = document.getElementById('loc')


// prompt_button.onclick = function(){
//     const text = textbox_div.querySelector('textarea').value;
//     console.log(text);
// }



async function send() {
  const res = await fetch("http://localhost:8000/double", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ number: 5 })
  });

  const data = await res.json();
  document.getElementById("output").innerText = data.result;
}


async function sendPrompt(input_prompt) {
  const res = await fetch("http://localhost:8000/chat", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ prompt: input_prompt })
  });

  const data = await res.json();
  document.getElementById("AI_res").innerText = data.result;
}

send_button.onclick = send;

prompt_button.onclick = function(){
    const text = textbox_div.querySelector('textarea').value;
    sendPrompt(text);
}


// async function sendLocation() {
//     if (navigator.geolocation) {
//         navigator.geolocation.getCurrentPosition(async (position) => {
//             const payload = {
//                 lat: position.coords.latitude,
//                 lon: position.coords.longitude
//             };

//             // Using async/await for cleaner code
//             try {
//                 const response = await fetch('http://127.0.0.1:8000/get-location', {
//                     method: 'POST',
//                     headers: { 'Content-Type': 'application/json' },
//                     body: JSON.stringify(payload)
//                 });
//                 const result = await response.json();
//                 textbox_div.querySelector('textarea').value = result;
//                 console.log(result);
//             } catch (error) {
//                 console.error("Error sending to FastAPI:", error);
//             }
//         });
//     }
// }

// window.onload = function() {
//     sendLocation();
// };


async function sendLocation() {
    console.log("Attempting to get location..."); // Debugging line

    if (!navigator.geolocation) {
        console.error("Geolocation not supported");
        return;
    }

    navigator.geolocation.getCurrentPosition(
        async (position) => {
            const coords = {
                lat: position.coords.latitude,
                lon: position.coords.longitude
            };
            console.log("Coords captured:", coords);

            // 2. Send to FastAPI
            try {
                const response = await fetch('http://127.0.0.1:8000/get-location', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(coords)
                });
                const result = await response.json();
                console.log("Backend response:", result);
            } catch (err) {
                console.error("Fetch error:", err);
            }
        },
        (error) => {
            // This is crucial for debugging!
            console.error("Geolocation Error Code: " + error.code + " - " + error.message);
        },
        { enableHighAccuracy: true, timeout: 10000 }
    );
}

// 3. Call it when the window loads
// window.onload = sendLocation;


loc_button.onclick = sendLocation


