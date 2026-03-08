$(document).ready(function () {

    $.ajax({
        type: "POST",
        url: "index.aspx/GetRevenueChart",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            const rawData = response.d;

            const labels = rawData.map(x => x.month);
            const data = rawData.map(x => x.revenue);

            renderChart(labels, data);
        }
    });

    function formatCurrency(value) {
        return value.toLocaleString('vi-VN') + " ₫";
    }

    function renderChart(labels, data) {

        const ctx = document.getElementById('revenueChart').getContext('2d');

        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, "rgba(59,130,246,0.35)");
        gradient.addColorStop(1, "rgba(59,130,246,0.02)");

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    borderColor: "#3b82f6",
                    backgroundColor: gradient,
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 8,
                    pointBackgroundColor: "#3b82f6"
                }]
            },
            options: {
                responsive: true,
                interaction: {
                    mode: 'index',
                    intersect: false
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return formatCurrency(context.raw);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return formatCurrency(value);
                            }
                        },
                        grid: {
                            color: "rgba(0,0,0,0.05)"
                        }
                    }
                }
            }
        });
    }
});