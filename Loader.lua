getgenv().loadModuleScript = function(script)
    return loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/TheXSVV/HUB2/main/' .. script .. '.lua'))()
end
getgenv().window = loadModuleScript('UI/Window')
getgenv().tab = loadModuleScript('API/Tab')
getgenv().checkbox = loadModuleScript('API/Settings/Checkbox')
getgenv().slider = loadModuleScript('API/Settings/Slider')

loadModuleScript('Features/TestFeature')
window.init().show()
