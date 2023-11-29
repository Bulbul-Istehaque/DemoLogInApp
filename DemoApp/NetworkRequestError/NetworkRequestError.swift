//
//  NetworkRequestError.swift
//  DemoApp
//
//  Created by Bul on 27/11/23.
//

import Foundation

struct NetworkRequestError {
    
    private init() {}
    
    static func getDisplayableErrorMessage(ForError error: Error) -> (String?, URLError.Code?) {
        
        guard let urlError = error as? URLError else { return (nil, nil) }
        
        var message: String?
        
        switch urlError.code {
        case .unknown:
            message = "Something went wrong"
            break

            case .cancelled: 
            message = "Request is cancelled"
            break

            case .badURL:
            break

            case .timedOut: 
            message = "Timed Out"
            break

            case .unsupportedURL:
            break

            case .cannotFindHost: 
            message = "Server is unavailable"
            break

            case .cannotConnectToHost: 
            message = "Server is unavailable"
            break

            case .networkConnectionLost: 
            message = "Please check your internet connection"
            break

            case .dnsLookupFailed: 
            message = "Server is unavailable"
            break

            case .httpTooManyRedirects:
            break

            case .resourceUnavailable:
            break

            case .notConnectedToInternet: 
            message = "Please check your internet connection"
            break

            case .redirectToNonExistentLocation:
            break

            case .badServerResponse: 
            message = "Invalid response"
            break

            case .userCancelledAuthentication:
            break

            case .userAuthenticationRequired:
            break

            case .zeroByteResource: 
            message = "No response"
            break

            case .cannotDecodeRawData: 
            message = "Invalid response"
            break

            case .cannotDecodeContentData: 
            message = "Invalid response"
            break

            case .cannotParseResponse: 
            message = "Invalid response"
            break

            case .appTransportSecurityRequiresSecureConnection: 
            message = "Unsecure server"
            break

            case .fileDoesNotExist:
            break

            case .fileIsDirectory:
            break

            case .noPermissionsToReadFile:
            break

            case .dataLengthExceedsMaximum:
            break

            case .secureConnectionFailed: 
            message = "Unsecure server"
            break

            case .serverCertificateHasBadDate: 
            message = "Unsecure server"
            break

            case .serverCertificateUntrusted: 
            message = "Untrusted server"
            break

            case .serverCertificateHasUnknownRoot: 
            message = "Unsecure server"
            break

            case .serverCertificateNotYetValid: 
            message = "Unsecure server"
            break

            case .clientCertificateRejected:
            break

            case .clientCertificateRequired:
            break

            case .cannotLoadFromNetwork:
            break

            case .cannotCreateFile:
            break

            case .cannotOpenFile:
            break

            case .cannotCloseFile:
            break

            case .cannotWriteToFile:
            break

            case .cannotRemoveFile:
            break

            case .cannotMoveFile:
            break

            case .downloadDecodingFailedMidStream:
            message = "Download failed"
            break

            case .downloadDecodingFailedToComplete: 
            message = "Download failed"
            break

            case .internationalRoamingOff: 
            message = "International roaming is off. Please contact service provider"
            break

            case .callIsActive: 
            message = "A call is ongoing. Please try again later"
            break

            case .dataNotAllowed: 
            message = "Connection stopped by provider"
            break

            case .requestBodyStreamExhausted:
            break

            case .backgroundSessionRequiresSharedContainer:
            break

            case .backgroundSessionInUseByAnotherProcess:
            break

            case .backgroundSessionWasDisconnected:
            message = "Session was stopped. Please try again"
            break
        
        default:
            break
        }
        return (message, urlError.code)
    }
    
}
