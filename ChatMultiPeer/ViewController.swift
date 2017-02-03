//
//  ViewController.swift
//  ChatMultiPeer
//
//  Created by Swift on 03/02/17.
//  Copyright © 2017 Quaddro. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var textFieldMensagem: UITextField!
    
    @IBOutlet weak var textViewConversas: UITextView!
    
    //MARK: Propriedades
    
    var meuBuscador : MCBrowserViewController!
    var meuAdvertiser : MCAdvertiserAssistant!
    var minhaSecao : MCSession!
    var meuPeerID : MCPeerID!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Propriedades de textField
        self.textFieldMensagem.delegate = self
        
        //Iniciando o Peer ID
        
        //comando para pegar informacoes do device (nome, modelo, versao, batteria)
        self.meuPeerID = MCPeerID(displayName: UIDevice.current.name)
        
        //Iniciando uma Seção
        self.minhaSecao = MCSession(peer: meuPeerID)
        self.minhaSecao.delegate = self
        
        //Iniciando o Buscador
        self.meuBuscador = MCBrowserViewController(serviceType: "chat", session: minhaSecao)
        self.meuBuscador.delegate = self
        
        //Iniciando o Advertiser = avisa quem entrou e quem saiu
        self.meuAdvertiser = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: minhaSecao)
        
    }

    //MARK: Actions
    
    @IBAction func btnBuscar(_ sender: UIButton) {
        
        self.present(meuBuscador, animated: true, completion: nil)
        self.meuAdvertiser.start()
        
    }

    //MARK: Métodos de MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        print("Pressionou Done")
        
        self.meuBuscador.dismiss(animated: true, completion: nil)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
        print("Cancelou a busca")
        
        self.meuBuscador.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Métodos Próprios
    func tratarMensagem(mensagem umaMensagem : String, peer umPeer : MCPeerID){
        
        var textoFinal = ""

        if umPeer == self.meuPeerID {
            
            textoFinal = "\nEU: \(umaMensagem)"
            
        } else {
            
            textoFinal = "\n \(umPeer.displayName): \(umaMensagem)"
            
        }
        
        self.textViewConversas.text! += textoFinal
    }
    
    func enviarMensagem() {
        
        let mensagem = self.textFieldMensagem.text!
        
        self.textFieldMensagem.text = ""
        
        let dado = mensagem.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        
        do {
            
            try self.minhaSecao.send(dado, toPeers: minhaSecao.connectedPeers, with: MCSessionSendDataMode.reliable)
            
        } catch {}
        
        tratarMensagem(mensagem: mensagem, peer: meuPeerID)
        
    }
    
    //MARK: Métodos de UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if !(self.textFieldMensagem.text!.isEmpty){
            
            enviarMensagem()
            
        }
        
        textFieldMensagem.resignFirstResponder()
        
        return true
        
    }
    
    //MARK: MCSessionDelegate
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let mensagem = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
        
        DispatchQueue.main.async{
            
            self.tratarMensagem(mensagem: mensagem!, peer: peerID)
            
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        //método vazio!
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        //método vazio!
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
        //método vazio!
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        //método vazio!
        
    }

}

