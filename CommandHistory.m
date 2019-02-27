legend(app.UIAxes,{' Si',' WSe2-Monolayer',' MoTe2-Monolayer','Heterojunction'},'FontSize',14);legend(app.UIAxes,'boxoff');
legend(app.UIAxes,{' WSe2-Monolayer','Heterojunction1','Heterojunction2'},'FontSize',14);legend(app.UIAxes,'boxoff');
legend(app.UIAxes,{' MoTe2-Bulk',' MoTe2-Multilayer',' MoTe2-Multilayer-2',' MoTe2-Monolayer'},'FontSize',14);

app.lineObj1.LineWidth = 1.2;
app.lineObj2.LineWidth = 1.2;
app.lineObj3.LineWidth = 1.2;
app.lineObj4.LineWidth = 1.2;

value = app.lineObj1.XData;
app.UIAxes.Title.String = "Sample 4";