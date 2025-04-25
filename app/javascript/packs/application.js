// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Webpack で自動コンパイルされるファイル
import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

// ✅ Chart.js のインポートと登録の最適化
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

Rails.start();
Turbolinks.start();
ActiveStorage.start();

// Ajax のイベント処理
$(document).on("ajax:success", ".favorite-btn", function (event, data) {
  console.log("Ajaxリクエスト成功", data);
  var bookId = data.book_id;
  var favoritesCount = data.favorites_count;

  $("#book_" + bookId).find(".favorites-count").html(favoritesCount);
  $("#book_" + bookId).find(".favorite-btn").replaceWith(data.favorite_button_html);
});

// Chart.js のグラフ描画処理
document.addEventListener("turbolinks:load", function () {
  const chartDataElement = document.getElementById("chart-data");
  const canvas = document.getElementById("postsChart");

  if (!chartDataElement || !canvas) {
    console.warn("Chart.js のデータが見つかりません");
    return;
  }

  try {
    const ctx = canvas.getContext("2d");
    const dates = JSON.parse(chartDataElement.dataset.dates || "[]");
    const counts = JSON.parse(chartDataElement.dataset.counts || "[]");

    console.log("chart_dates:", dates);
    console.log("chart_counts:", counts);

    if (dates.length === 0 || counts.length === 0) {
      console.warn("Chart.js のデータが空です");
      return;
    }

    // ✅ 既存のグラフを適切に破棄
    if (window.myChart) {
      window.myChart.destroy();
    }

    // ✅ Chart.js のスケール設定修正 (yAxes → y)
    window.myChart = new Chart(ctx, {
      type: "line",
      data: {
        labels: dates,
        datasets: [
          {
            label: "投稿数",
            data: counts,
            borderColor: "rgba(75, 192, 192, 1)",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            borderWidth: 2,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            stepSize: 1,
            ticks: {
              callback: function (value) {
                return value;
              },
            },
          },
        },
      },
    });
  } catch (error) {
    console.error("Chart.js のデータ処理中にエラーが発生しました:", error);
  }
});









