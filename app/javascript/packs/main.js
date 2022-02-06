const outputEl = document.getElementById("output");
const formEl = document.querySelector(".form");

formEl.addEventListener("ajax:beforeSend", (e) => {
  e.preventDefault();
  const item = document.getElementById("items").value;
  const number = Number(document.getElementById("number").value);

  fetch("/calculate", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      item: item,
      number: number,
      authenticity_token: document.querySelector(
        'input[name="authenticity_token"]'
      ).value,
    }),
  })
    .then((res) => res.json())
    .then((data) => {
      if (data.error) {
        outputEl.innerHTML = `
          <div class="output__error">${data.error}</div>
        `;
      } else {
        let lis = "";
        const parsedData = JSON.parse(data.output);

        const totalCost = parsedData.reduce((previousValue, currentValue) => {
          return (
            previousValue + currentValue.quantity * currentValue.pack_price
          );
        }, 0);
        parsedData.map((item) => {
          lis += `<li>${item.quantity} x ${item.pack_number} @ $${
            item.pack_price / 100
          }</li>`;
        });
        outputEl.innerHTML = `
          <div class="output__body">
            <p>Getting ${number} ${parsedData[0].name} will cost you $${
          totalCost / 100
        }</p>
            <ul>
              ${lis}
            </ul>
          </div>
        `;
      }
    })
    .catch((err) => {
      outputEl.innerHTML = `
          <div class="output__error">Something went wrong with the server. Please try again another time.</div>
        `;
      console.log(err);
    });
});
