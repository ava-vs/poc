import { ver } from "../../declarations/ver";
import { rep } from "../../declarations/rep";

//get reputation balance

document.getElementById("getBalanceButton").addEventListener("click", async (e) => {
  e.preventDefault();
  const button = e.target;

  const name = document.getElementById("name").value.toString();

  button.setAttribute("disabled", true);
  let res_balance;
  try {
     res_balance = await ver.getBalance(name);
    document.getElementById("balanceResult").innerText = "Current Balance (canister Ver): " + res_balance;
} catch (error) {
    console.error("Error getting balance:", error);
    document.getElementById("balanceResult").innerText = "Error getting balance!";
}

  button.removeAttribute("disabled");

  document.getElementById("balanceResult").innerText = res_balance;
  
});

// all users

document.getElementById("getAllUsers").addEventListener("click", async (e) => {
  e.preventDefault();
  const button = e.target;

  button.setAttribute("disabled", true);
  let all_users;
  try {
    all_users = await rep.getUsers();

    const tableBody = document.getElementById("usersTableBody");
    tableBody.innerHTML = ""; 

  all_users.forEach(user => {
    // Создаем новую строку и ячейки для Principal и Int
    const row = document.createElement("tr");
    const principalCell = document.createElement("td");
    const intCell = document.createElement("td");

    // Заполняем ячейки данными из массива
    principalCell.textContent = user[0] || "ao6hk-x5zgr-aa6y2-zq5ei-meewq-doeim-hwbws-zzxql-rjtcc-hmabt-xqe";
    intCell.textContent = user[1] || "unknown";

    // Добавляем ячейки в строку
    row.appendChild(principalCell);
    row.appendChild(intCell);

    // Добавляем строку в tbody
    tableBody.appendChild(row);
});
  } catch (error) {
    console.error("Error getting users:", error);
    document.getElementById("errorOutput").innerText = "Error getting users!"; 
  }

  button.removeAttribute("disabled");
});


// increase reputation

document.getElementById("increaseRepoButton").addEventListener("click", async (e) => {
  e.preventDefault();
  const button = e.target;

  const user = document.getElementById("user").value.toString();
  button.setAttribute("disabled", true);

    // Interact with rep actor, calling the increase method
    try {
      await rep.incrementBalance(user, 1);
      document.getElementById("increaseResult").innerText = "Reputation in canisted Rep increased!";
  } catch (error) {
      console.error("Error getting balance:", error);
      document.getElementById("increaseResult").innerText = "Error getting balance!";
  }  
    
    button.removeAttribute("disabled");   

});
