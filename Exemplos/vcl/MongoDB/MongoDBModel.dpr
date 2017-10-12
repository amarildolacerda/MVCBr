program MongoDBModel;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  MongoDBModel.Controller in 'Controllers\MongoDBModel.Controller.pas',
  MVCBr.MongoModel in '..\..\..\MVCBr.MongoModel.pas',
  MongoDBModel.Controller.Interf in 'Controllers\MongoDBModel.Controller.Interf.pas',
  MongoDBModelView in 'Views\MongoDBModelView.pas' {MongoDBModelView},
  MVCBr.FDMongoDB in '..\..\..\MVCBr.FDMongoDB.pas';

begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TMongoDBModelController.New);
end.
