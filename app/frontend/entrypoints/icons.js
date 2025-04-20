import { createIcons, icons } from 'lucide';

document.addEventListener('DOMContentLoaded', () => {
  createIcons({
    icons: icons,
    nameAttr: 'data-icon'
  });
});
