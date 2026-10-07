// ===================================================
// AURA (MEMORY AI) - INTERACTIVE CONTROLLER
// ===================================================

class AuraApp {
  constructor() {
    this.currentTab = 'today';
    this.todayViewMode = 'list'; // 'list' | 'grid'
    this.dayRange = 1; // 1 | 3 | 7
    this.onboardingStep = 0;
    this.totalOnboardingSteps = 5;
    this.theme = 'dark';
    this.isFrameless = false;
    this.activeModals = [];

    this.init();
  }

  init() {
    // Update live clock
    this.updateClock();
    setInterval(() => this.updateClock(), 60000);

    // Initialize lucide icons
    if (window.lucide) {
      window.lucide.createIcons();
    }

    // Bind date strip click handlers
    const dateCols = document.querySelectorAll('.date-col');
    dateCols.forEach(col => {
      col.addEventListener('click', () => {
        dateCols.forEach(c => c.classList.remove('selected'));
        col.classList.add('selected');
        const day = col.getAttribute('data-day');
        this.showToast(`Selected October ${day}, 2026`);
      });
    });

    // Enter key to send chat
    const chatInput = document.getElementById('chatInputField');
    if (chatInput) {
      chatInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          this.handleUserSend();
        }
      });
    }

    // Close dropdowns on outside click
    document.addEventListener('click', (e) => {
      const fabBtn = document.getElementById('btnFabAdd');
      const fabMenu = document.getElementById('fabMenu');
      if (fabMenu && fabMenu.classList.contains('open') && !fabMenu.contains(e.target) && !fabBtn.contains(e.target)) {
        this.toggleFabMenu(false);
      }

      const filterBtn = document.getElementById('btnFilterLayers');
      const filterMenu = document.getElementById('filterDropdown');
      if (filterMenu && filterMenu.classList.contains('open') && !filterMenu.contains(e.target) && !filterBtn.contains(e.target)) {
        filterMenu.classList.remove('open');
      }
    });
  }

  updateClock() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const timeElem = document.getElementById('currentTime');
    if (timeElem) timeElem.textContent = `${hours}:${minutes}`;
  }

  // ================= NAVIGATION =================
  setScreen(tabName) {
    this.currentTab = tabName;

    // Update screen pages
    document.querySelectorAll('.tab-page').forEach(page => {
      page.classList.remove('active');
    });
    const targetPage = document.getElementById(`tab-${tabName}`);
    if (targetPage) targetPage.classList.add('active');

    // Update bottom tab bar
    document.querySelectorAll('.tab-item').forEach(btn => {
      btn.classList.remove('active');
      if (btn.getAttribute('data-tab') === tabName) {
        btn.classList.add('active');
      }
    });

    // Update desktop sidebar buttons
    document.querySelectorAll('.control-btn').forEach(btn => {
      btn.classList.remove('active');
      const btnText = btn.textContent.toLowerCase();
      if (btnText.includes(tabName)) {
        btn.classList.add('active');
      }
    });

    // Close any context menu if open
    this.toggleFabMenu(false);
  }

  // ================= TODAY TAB ACTIONS =================
  setTodayView(mode) {
    this.todayViewMode = mode;
    const btnList = document.getElementById('btnViewList');
    const btnGrid = document.getElementById('btnViewGrid');
    const dayRangeSelector = document.getElementById('dayRangeSelector');
    const emptyState = document.getElementById('todayEmptyState');
    const timelineView = document.getElementById('todayTimelineView');

    if (mode === 'list') {
      btnList.classList.add('active');
      btnGrid.classList.remove('active');
      dayRangeSelector.classList.add('hidden');
      emptyState.classList.remove('hidden');
      timelineView.classList.add('hidden');
    } else {
      btnList.classList.remove('active');
      btnGrid.classList.add('active');
      dayRangeSelector.classList.remove('hidden');
      emptyState.classList.add('hidden');
      timelineView.classList.remove('hidden');
    }
  }

  setDayRange(range) {
    this.dayRange = range;
    const rangeBtns = document.querySelectorAll('.range-btn');
    rangeBtns.forEach(btn => {
      btn.classList.remove('active');
      if (btn.textContent.trim() === String(range)) {
        btn.classList.add('active');
      }
    });
    this.showToast(`Switched to ${range}-day view`);
  }

  toggleFabMenu(forceState) {
    const menu = document.getElementById('fabMenu');
    const fabBtn = document.getElementById('btnFabAdd');
    if (!menu || !fabBtn) return;

    const isOpen = forceState !== undefined ? forceState : !menu.classList.contains('open');
    if (isOpen) {
      menu.classList.add('open');
      fabBtn.classList.add('active');
    } else {
      menu.classList.remove('open');
      fabBtn.classList.remove('active');
    }
  }

  toggleTodayFilter() {
    const filterMenu = document.getElementById('filterDropdown');
    if (filterMenu) {
      filterMenu.classList.toggle('open');
    }
  }

  triggerAddAction(type) {
    this.toggleFabMenu(false);
    this.showToast(`Created new ${type}`);
    if (type === 'task') {
      this.setScreen('tasks');
    } else if (type === 'reminder') {
      this.setScreen('chat');
    }
  }

  openNewEventModal() {
    this.setScreen('chat');
    this.sendPresetMessage('Plan a new event for today at 4:00 PM');
  }

  // ================= CHAT TAB ACTIONS =================
  handleUserSend() {
    const input = document.getElementById('chatInputField');
    if (!input || !input.value.trim()) return;

    const userText = input.value.trim();
    input.value = '';
    this.appendUserMessage(userText);

    // AI typing animation
    const thinking = document.getElementById('aiStatusThinking');
    if (thinking) thinking.style.display = 'flex';

    setTimeout(() => {
      if (thinking) thinking.style.display = 'none';
      this.generateAiResponse(userText);
    }, 1200);
  }

  sendPresetMessage(text) {
    this.appendUserMessage(text);
    const thinking = document.getElementById('aiStatusThinking');
    if (thinking) thinking.style.display = 'flex';

    setTimeout(() => {
      if (thinking) thinking.style.display = 'none';
      this.generateAiResponse(text);
    }, 1000);
  }

  appendUserMessage(text) {
    const container = document.getElementById('chatMessages');
    const bubble = document.createElement('div');
    bubble.className = 'chat-bubble user-bubble';
    bubble.innerHTML = `<p>${this.escapeHtml(text)}</p>`;

    const thinking = document.getElementById('aiStatusThinking');
    container.insertBefore(bubble, thinking);
    container.scrollTop = container.scrollHeight;
  }

  appendAiMessage(htmlContent) {
    const container = document.getElementById('chatMessages');
    const bubble = document.createElement('div');
    bubble.className = 'chat-bubble ai-bubble';
    bubble.innerHTML = htmlContent;

    const thinking = document.getElementById('aiStatusThinking');
    container.insertBefore(bubble, thinking);
    container.scrollTop = container.scrollHeight;

    if (window.lucide) window.lucide.createIcons();
  }

  generateAiResponse(prompt) {
    const lower = prompt.toLowerCase();
    let reply = '';

    if (lower.includes('weather')) {
      reply = `
        <p>Current forecast for Hanoi: 28°C, Partly cloudy with gentle breeze. Tomorrow expected high 31°C.</p>
        <div class="weather-mini-widget mt-2" style="max-width: 280px;">
          <div class="weather-top"><span class="city">HANOI</span><span class="temp">28°C</span></div>
          <div class="weather-bottom">Partly cloudy ↑31° ↓24°</div>
        </div>
      `;
    } else if (lower.includes('news') || lower.includes('digest')) {
      reply = `
        <p>I've scheduled your <strong>AI & Tech Digest</strong> every morning at 09:00 AM.</p>
        <p class="muted-note">Top story right now: Anthropic and OpenAI announce next-gen multimodality milestones.</p>
      `;
    } else if (lower.includes('bitcoin') || lower.includes('price')) {
      reply = `
        <p>Bitcoin is currently trading at <strong>$64,820</strong> (+2.4% in 24h).</p>
      `;
    } else if (lower.includes('motivation')) {
      reply = `
        <p>"The best way to predict the future is to create it." — You're making tremendous progress today, Minh!</p>
      `;
    } else {
      reply = `
        <p>Got it! I saved "<strong>${this.escapeHtml(prompt)}</strong>" and will keep track of it in your calendar.</p>
      `;
    }

    this.appendAiMessage(reply);
  }

  dismissActiveTag() {
    const chip = document.getElementById('chatActiveChip');
    if (chip) chip.style.display = 'none';
  }

  toggleVoiceInput() {
    const mic = document.getElementById('btnMic');
    mic.classList.toggle('text-orange');
    this.showToast('Voice listening activated... Speak now');
    setTimeout(() => {
      mic.classList.remove('text-orange');
      const input = document.getElementById('chatInputField');
      if (input) input.value = 'Schedule a focus block at 10 AM';
    }, 2000);
  }

  // ================= TASKS TAB ACTIONS =================
  toggleRoutine(button) {
    button.classList.toggle('active');
    if (button.classList.contains('active')) {
      button.textContent = 'Turned on';
      this.showToast('Routine enabled — Nova will notify you daily');
    } else {
      button.textContent = 'Turn on';
      this.showToast('Routine disabled');
    }
  }

  openNewTaskModal() {
    this.showPrompt('New Routine Task', 'Describe a recurring automation for Nova:');
  }

  // ================= ONBOARDING & PAYWALL =================
  openOnboarding() {
    this.onboardingStep = 0;
    this.renderOnboardingSlide();
    const modal = document.getElementById('onboardingScreen');
    if (modal) modal.classList.remove('hidden');
  }

  closeOnboarding() {
    const modal = document.getElementById('onboardingScreen');
    if (modal) modal.classList.add('hidden');
  }

  renderOnboardingSlide() {
    const slides = document.querySelectorAll('.onboarding-slide');
    const dots = document.querySelectorAll('.step-dot');
    const backBtn = document.getElementById('btnOnboardBack');
    const nextBtn = document.getElementById('btnOnboardNext');

    slides.forEach((slide, i) => {
      slide.classList.toggle('active', i === this.onboardingStep);
    });

    dots.forEach((dot, i) => {
      dot.classList.toggle('active', i === this.onboardingStep);
    });

    // Back button visibility
    if (this.onboardingStep > 0 && this.onboardingStep < 4) {
      backBtn.classList.remove('hidden');
    } else {
      backBtn.classList.add('hidden');
    }

    // Button label
    if (this.onboardingStep === 3) {
      nextBtn.textContent = 'Turn on notifications';
    } else if (this.onboardingStep === 4) {
      nextBtn.textContent = 'Start 3-Day Free Trial';
    } else {
      nextBtn.textContent = 'Next';
    }
  }

  nextOnboardingStep() {
    if (this.onboardingStep < this.totalOnboardingSteps - 1) {
      this.onboardingStep++;
      this.renderOnboardingSlide();
    } else {
      this.showToast('🎉 Free Trial activated! Welcome to Memory AI');
      this.closeOnboarding();
      this.setScreen('today');
    }
  }

  prevOnboardingStep() {
    if (this.onboardingStep > 0) {
      this.onboardingStep--;
      this.renderOnboardingSlide();
    }
  }

  selectPlan(card) {
    document.querySelectorAll('.plan-card').forEach(p => p.classList.remove('selected', 'highlight-plan'));
    card.classList.add('selected', 'highlight-plan');
  }

  // ================= SUB-MODALS =================
  openModal(name) {
    const map = {
      'capabilities': 'modalCapabilities',
      'connected-apps': 'modalConnectedApps',
      'usage': 'modalUsage',
      'widgets': 'modalWidgets',
      'live-activities': 'modalLiveActivities',
      'calendar': 'modalCalendar',
      'what-memory-knows': 'modalWhatMemoryKnows',
      'languages': 'modalLanguages',
      'email': 'modalEmail'
    };

    const id = map[name];
    if (id) {
      const modal = document.getElementById(id);
      if (modal) {
        modal.classList.remove('hidden');
        this.activeModals.push(name);
        if (window.lucide) window.lucide.createIcons();
      }
    }
  }

  closeModal(name) {
    const map = {
      'capabilities': 'modalCapabilities',
      'connected-apps': 'modalConnectedApps',
      'usage': 'modalUsage',
      'widgets': 'modalWidgets',
      'live-activities': 'modalLiveActivities',
      'calendar': 'modalCalendar',
      'what-memory-knows': 'modalWhatMemoryKnows',
      'languages': 'modalLanguages',
      'email': 'modalEmail'
    };

    const id = map[name];
    if (id) {
      const modal = document.getElementById(id);
      if (modal) modal.classList.add('hidden');
    }
  }

  // Widgets preview size
  setWidgetSize(size) {
    const preview = document.getElementById('widgetPreviewBox');
    if (!preview) return;

    preview.className = `widget-preview-card ${size}`;
    const buttons = document.querySelectorAll('.wsize-btn');
    buttons.forEach(btn => {
      btn.classList.toggle('active', btn.textContent.toLowerCase() === size);
    });
  }

  // Live activities categories toggle
  toggleCategoryTile(tile) {
    tile.classList.toggle('selected');
  }

  // Language Selection
  selectLang(row) {
    document.querySelectorAll('.lang-row').forEach(r => {
      r.classList.remove('selected');
      const check = r.querySelector('.check');
      if (check) check.remove();
    });
    row.classList.add('selected');
    const checkSpan = document.createElement('span');
    checkSpan.className = 'check';
    checkSpan.textContent = '✓';
    row.appendChild(checkSpan);
    this.showToast(`Language set to ${row.textContent.trim()}`);
    setTimeout(() => this.closeModal('languages'), 600);
  }

  // ================= THEME & PRESENTATION =================
  setTheme(themeName) {
    this.theme = themeName;
    document.body.className = `theme-${themeName === 'system' ? 'dark' : themeName}`;

    // Update buttons in desktop sidebar
    const darkBtn = document.getElementById('btn-theme-dark');
    const lightBtn = document.getElementById('btn-theme-light');
    if (darkBtn && lightBtn) {
      darkBtn.classList.toggle('active', themeName === 'dark');
      lightBtn.classList.toggle('active', themeName === 'light');
    }

    // Update appearance radio options in profile
    document.querySelectorAll('.theme-card-option').forEach(card => {
      const text = card.textContent.toLowerCase();
      const isSelected = text.includes(themeName);
      card.classList.toggle('selected', isSelected);
      const dot = card.querySelector('.radio-dot');
      if (dot) dot.classList.toggle('active', isSelected);
    });

    this.showToast(`Theme switched to ${themeName}`);
  }

  toggleDeviceFrame() {
    const frame = document.getElementById('iphoneFrame');
    if (!frame) return;
    this.isFrameless = !this.isFrameless;
    frame.classList.toggle('frameless', this.isFrameless);
  }

  // ================= UTILITIES =================
  showToast(message) {
    const toast = document.getElementById('toastBox');
    if (!toast) return;

    toast.textContent = message;
    toast.classList.add('show');
    clearTimeout(this.toastTimer);
    this.toastTimer = setTimeout(() => {
      toast.classList.remove('show');
    }, 2600);
  }

  showPrompt(title, subtitle) {
    const result = prompt(`${title}\n${subtitle}`);
    if (result) {
      this.showToast(`Saved: "${result}"`);
    }
  }

  escapeHtml(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }
}

// Instantiate globally
document.addEventListener('DOMContentLoaded', () => {
  window.app = new AuraApp();
});
