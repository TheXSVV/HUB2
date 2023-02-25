local testTab = tab:new('Aimbot tab')
testTab:register_setting(checkbox:new('Test checkbox', false))
testTab:register_setting(checkbox:new('Test checkbox 2', true))
testTab:register_setting(slider:new('Test slider', 4, 60, 1, 20))
window.register_tab(testTab)

window.register_tab(tab:new('Empty tab'))
