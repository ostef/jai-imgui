call vcvars64
if not exist lib mkdir lib
pushd lib
call cl /c ../../imgui/imgui.cpp ../../imgui/imgui_draw.cpp ../../imgui/imgui_demo.cpp ../../imgui/imgui_widgets.cpp
call lib imgui.obj imgui_demo.obj imgui_draw.obj imgui_widgets.obj /OUT:ImGui.lib
del imgui.obj
del imgui_demo.obj
del imgui_draw.obj
del imgui_widgets.obj
popd lib
