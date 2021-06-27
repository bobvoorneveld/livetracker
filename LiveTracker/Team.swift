//
//  Team.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import SwiftUI

struct Team {
    let id: String
    let name: String
    let jerseyURL: URL
}

extension Team {
    static let teams: [Team] = [
        Team(
            id: "8e18d8f96f10d2c0131d4fc7ce668eeb1e61f60acd020df57f0562301451998f",
            name: "Movistar Team",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/mov/26368/0:0,400:400-60-0-70/ac4b9")!
        ),
        Team(
            id: "72c08593dd639a5e4c2c6c51a6c1ed5cda3f27f39de1bb861ebf99d55638a153",
            name: "Total Energies",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/total-energies-2021-ok/28602/0:0,400:400-60-0-70/8cf01")!
        ),
        Team(
            id: "0fae82eab30a334b6d51f8dde0c6408f24c62e385259c145c7c6d65901374d81",
            name: "Astana – Premier Tech",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/ast/26355/0:0,400:400-60-0-70/4be14")!
        ),
        Team(
            id: "1ae3118b8a4fbc5e2ef905cf09e81f6c5726cfacad377112f9456710e2e155d6",
            name: "Groupama – FDJ",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/gfc/26363/0:0,400:400-60-0-70/2ddc1")!
        ),
        Team(
            id: "b7d894de3d5350e71b88becc69f4148f6e3b699101179467a310d842524a2559",
            name: "Team Qhubeka Assos",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/tqa/26373/0:0,400:400-60-0-70/92696")!
        ),
        Team(
            id: "9c14f8e3697e26fc2f1232682d987098be81509ba527d0c069363d967a85305e",
            name: "Cofidis",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/cof/26359/0:0,400:400-60-0-70/dc73c")!
        ),
        Team(
            id: "1987a8172ed88458e3faad3aa99cb12278332ea49659618cb4e31ec66dec7e91",
            name: "Ineos Grenadier",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/igd/26364/0:0,400:400-60-0-70/1b92c")!
        ),
        Team(
            id: "a91733cccdfcd40e1eae9b7a7a466b2e146f929b40f45d56a252cb484e278bb3",
            name: "Team Arkéa – Samsic",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/ark/26354/0:0,400:400-60-0-70/99dd6")!
        ),
        Team(
            id: "520020a03168134d87b2f367e08c7b5fd931767ac0191289f364d925c41e5327",
            name: "Intermarché – Wanty – Gobert Matériaux",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/iwg/26366/0:0,400:400-60-0-70/0587c")!
        ),
        Team(
            id: "eb527a08cde713a9d3a4809d1c370a5b2978a29a8c5a6d1d4408ec2d88e74d76",
            name: "Team BikeExchange",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/bex/26357/0:0,400:400-60-0-70/fec70")!
        ),
        Team(
            id: "c75a447aed2f34966bbd982292bea171f49386b756ac024744c1cb74c73f75cc",
            name: "Bora – Hansgrohe",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-cdd-png/boh/3616/0:0,400:400-60-0-70/7e4f0")!
        ),
        Team(
            id: "a06980928e71c69a04cdc62b1314a8e56bffd2a47bfe6c01dc14153289602343",
            name: "Deceuninck – Quick-Step",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/dqt/26360/0:0,400:400-60-0-70/9b279")!
        ),
        Team(
            id: "bb1472f3aa92a52cdcfccc777fe4954ce91f29de29e5c1f7c4c3ffd0a26357e1",
            name: "Lotto Soudal",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/lts/26367/0:0,400:400-60-0-70/a9db5")!
        ),
        Team(
            id: "a5fc244b10c389e1e1c747ab636cf6d969fc51bbefa93603e1c0e39ca86a4430",
            name: "B&B Hotels P/B KTM",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/bbk/26356/0:0,400:400-60-0-70/9e58c")!
        ),
        Team(
            id: "d3316eb650bfe23062914c46d94752803cee9f393cfd74216b4d16329ab373bd",
            name: "AG2R Citroën Team",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/act/26352/0:0,400:400-60-0-70/b4b27")!
        ),
        Team(
            id: "d920f2e4dd63d77614c2f99bcdc97e7a14f33551e2fd4b6cf341dd8adf160382",
            name: "Alpecin – Fenix",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/afc/26353/0:0,400:400-60-0-70/458e8")!
        ),
        Team(
            id: "4742f664ca7c868554f86820ca18303eb70a1f49daf8e4c64c8958013f1d3635",
            name: "Israel Start-Up Nation",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/isn/26365/0:0,400:400-60-0-70/dc72f")!
        ),
        Team(
            id: "0088f9e8a23e42e2537cbe1a63d42fcd7625e49c68478c9e12cd4b8f89b52795",
            name: "Team DSM",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/dsm/26361/0:0,400:400-60-0-70/cf75c")!
        ),
        Team(
            id: "4d8033514b407ca05950b8b2bdaa9e3f0322060e17e0c57455b059cdaa99462c",
            name: "UAE Team Emirates",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/uad/26374/0:0,400:400-60-0-70/b14b1")!
        ),
        Team(
            id: "ae3c1d9f7f99a6cf5070fc739f7a8f48809b2feb58a33b448fd34cc7cf782e1d",
            name: "Trek – Segafredo",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/tfs/26371/0:0,400:400-60-0-70/b7bb4")!
        ),
        Team(
            id: "86d30a985f2b02becb5c3d9a3bec41dc6f04596034dc242c6487c435fab5cc94",
            name: "Bahrain Victorious",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/bahrain-victorious-2021-ok/26797/0:0,400:400-60-0-70/f44f5")!
        ),
        Team(
            id: "d8ee0a75c63a08923ef9891e207cab5ed5c8796a3d08d2ab0d287915d5c39f01",
            name: "Jumbo – Visma",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/jumbo-visma-tdf-2021-ok/26796/0:0,400:400-60-0-70/439f5")!
        ),
        Team(
            id: "d366e356207e22eb583df76ced15f7f2a0e04f14424122c195974872b6153813",
            name: "EF Education – NIPPO",
            jerseyURL: URL(string: "https://img.aso.fr/core_app/img-cycling-tdf-png/efn/26362/0:0,400:400-60-0-70/2ea1d")!
        ),
    ]
}
